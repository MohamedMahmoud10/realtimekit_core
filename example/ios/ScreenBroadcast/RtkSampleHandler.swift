//
//  RtkSampleHandler.swift
//  ShareScreenExtension
//
//  Created by sudhir kumar on 29/05/24.
//  Copyright © 2024 orgName. All rights reserved.
//

import Foundation
import ReplayKit

@propertyWrapper
struct Atomic<Value> {
    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
        get { load() }
        set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}

private enum ScreenShareConstants {
    static let bufferMaxLength = 10240
}

private var printLogs = false
private class SampleUploader {
    private static var imageContext = CIContext(options: nil)

    @Atomic private var isReady = false
    private var connection: BroadcastUploadSocketConnection

    private var dataToSend: Data?
    private var byteIndex = 0

    private let serialQueue: DispatchQueue

    init(connection: BroadcastUploadSocketConnection) {
        self.connection = connection
        serialQueue = DispatchQueue(label: "SampleHandler")
        setupConnection()
    }

    @discardableResult func send(sample buffer: CMSampleBuffer) -> Bool {
        guard isReady else {
            return false
        }

        isReady = false

        dataToSend = prepare(sample: buffer)
        byteIndex = 0

        serialQueue.async { [weak self] in
            self?.sendDataChunk()
        }

        return true
    }
}

private extension SampleUploader {
    func setupConnection() {
        connection.didOpen = { [weak self] in
            if printLogs { NSLog("ScreenShare connection.didOpen") }
            self?.isReady = true
        }
        connection.streamHasSpaceAvailable = { [weak self] in
            self?.serialQueue.async {
                if let success = self?.sendDataChunk() {
                    self?.isReady = !success
                }
            }
        }
    }

    @discardableResult func sendDataChunk() -> Bool {
        guard let dataToSend else {
            return false
        }

        if printLogs { NSLog("ScreenShare sendDataChunk") }

        var bytesLeft = dataToSend.count - byteIndex
        var length = bytesLeft > ScreenShareConstants.bufferMaxLength ? ScreenShareConstants.bufferMaxLength : bytesLeft

        length = dataToSend[byteIndex ..< (byteIndex + length)].withUnsafeBytes {
            guard let ptr = $0.bindMemory(to: UInt8.self).baseAddress else {
                return 0
            }

            return connection.writeToStream(buffer: ptr, maxLength: length)
        }

        if length > 0 {
            byteIndex += length
            bytesLeft -= length

            if bytesLeft == 0 {
                self.dataToSend = nil
                byteIndex = 0
            }
        } else {
            if printLogs { NSLog("SS: writeBufferToStream failure") }
        }

        return true
    }

    func prepare(sample buffer: CMSampleBuffer) -> Data? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            if printLogs { NSLog("image buffer not available") }
            return nil
        }

        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)

        let scaleFactor = 1.0
        let width = CVPixelBufferGetWidth(imageBuffer) / Int(scaleFactor)
        let height = CVPixelBufferGetHeight(imageBuffer) / Int(scaleFactor)

        let orientation = CMGetAttachment(buffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil)?.uintValue ?? 0

        let scaleTransform = CGAffineTransform(scaleX: CGFloat(1.0 / scaleFactor), y: CGFloat(1.0 / scaleFactor))
        let bufferData = jpegData(from: imageBuffer, scale: scaleTransform)

        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)

        guard let messageData = bufferData else {
            if printLogs { NSLog("corrupted image buffer") }
            return nil
        }

        let httpResponse = CFHTTPMessageCreateResponse(nil, 200, nil, kCFHTTPVersion1_1).takeRetainedValue()
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Content-Length" as CFString, String(messageData.count) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Width" as CFString, String(width) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Height" as CFString, String(height) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Orientation" as CFString, String(orientation) as CFString)

        CFHTTPMessageSetBody(httpResponse, messageData as CFData)

        let serializedMessage = CFHTTPMessageCopySerializedMessage(httpResponse)?.takeRetainedValue() as Data?

        return serializedMessage
    }

    func jpegData(from buffer: CVPixelBuffer, scale scaleTransform: CGAffineTransform) -> Data? {
        let image = CIImage(cvPixelBuffer: buffer).transformed(by: scaleTransform)

        guard let colorSpace = image.colorSpace else {
            return nil
        }

        let options: [CIImageRepresentationOption: Float] = [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.6]

        return SampleUploader.imageContext.jpegRepresentation(of: image, colorSpace: colorSpace, options: options)
    }
}

private class BroadcastUploadSocketConnection: NSObject {
    var didOpen: (() -> Void)?
    var didClose: ((Error?) -> Void)?
    var streamHasSpaceAvailable: (() -> Void)?

    private let filePath: String
    private var socketHandle: Int32 = -1
    private var address: sockaddr_un?

    private var inputStream: InputStream?
    private var outputStream: OutputStream?

    private var networkQueue: DispatchQueue?
    private var shouldKeepRunning = false

    init?(filePath path: String) {
        filePath = path
        socketHandle = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)

        if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Init %@", filePath) }

        guard socketHandle != -1 else {
            return nil
        }
    }

    func open() -> Bool {
        if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection open") }

        guard FileManager.default.fileExists(atPath: filePath) else {
            if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Didn't open as file doesn't exist \(filePath)") }
            return false
        }

        guard setupAddress() == true else {
            if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Didn't open as Setupaddress is false") }
            return false
        }

        guard connectSocket() == true else {
            if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Didn't open as connectSocket is false") }

            return false
        }

        setupStreams()

        inputStream?.open()
        outputStream?.open()

        return true
    }

    func close() {
        unscheduleStreams()

        inputStream?.delegate = nil
        outputStream?.delegate = nil

        inputStream?.close()
        outputStream?.close()

        inputStream = nil
        outputStream = nil
    }

    func writeToStream(buffer: UnsafePointer<UInt8>, maxLength length: Int) -> Int {
        return outputStream?.write(buffer, maxLength: length) ?? 0
    }
}

extension BroadcastUploadSocketConnection: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            if aStream == outputStream {
                didOpen?()
            }
        case .hasBytesAvailable:
            if aStream == inputStream {
                var buffer: UInt8 = 0

                let numberOfBytesRead = inputStream?.read(&buffer, maxLength: 1)
                if numberOfBytesRead == 0, aStream.streamStatus == .atEnd {
                    close()
                    notifyDidClose(error: nil)
                }
            }
        case .hasSpaceAvailable:
            if aStream == outputStream {
                streamHasSpaceAvailable?()
            }
        case .errorOccurred:
            close()
            notifyDidClose(error: aStream.streamError)
        default:
            break
        }
    }
}

private extension BroadcastUploadSocketConnection {
    func setupAddress() -> Bool {
        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        guard filePath.count < MemoryLayout.size(ofValue: addr.sun_path) else {
            return false
        }

        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            filePath.withCString {
                strncpy(ptr, $0, filePath.count)
            }
        }

        address = addr
        return true
    }

    func connectSocket() -> Bool {
        guard var addr = address else {
            if printLogs { NSLog("ScreenShare connectSocket is false because Address is nil") }
            return false
        }

        let status = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(socketHandle, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }

        guard status == noErr else {
            if printLogs { NSLog("ScreenShare connectSocket is false because Status has error \(noErr)") }
            return false
        }

        return true
    }

    func setupStreams() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocket(kCFAllocatorDefault, socketHandle, &readStream, &writeStream)

        inputStream = readStream?.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))

        outputStream = writeStream?.takeRetainedValue()
        outputStream?.delegate = self
        outputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Creating Streams") }
        scheduleStreams()
    }

    func scheduleStreams() {
        shouldKeepRunning = true

        networkQueue = DispatchQueue.global(qos: .userInitiated)
        networkQueue?.async { [weak self] in
            if printLogs { NSLog("ScreenShare BroadcastUploadSocketConnection Scheduling Streams") }

            self?.inputStream?.schedule(in: .current, forMode: .common)
            self?.outputStream?.schedule(in: .current, forMode: .common)
            RunLoop.current.run()
            var isRunning = false
            repeat {
                isRunning = self?.shouldKeepRunning ?? false && RunLoop.current.run(mode: .default, before: .distantFuture)
            } while isRunning
        }
    }

    func unscheduleStreams() {
        networkQueue?.sync { [weak self] in
            self?.inputStream?.remove(from: .current, forMode: .common)
            self?.outputStream?.remove(from: .current, forMode: .common)
        }

        shouldKeepRunning = false
    }

    func notifyDidClose(error: Error?) {
        if printLogs { NSLog("ScreenShare notifyDidClose \(error)") }
        if didClose != nil {
            didClose?(error)
        }
    }
}

private enum DarwinNotification: String {
    case broadcastStarted
    case broadcastStopped
    case broadcastPaused
    case broadcastResumed
}

private class DarwinNotificationCenter {
    static let shared = DarwinNotificationCenter()

    private let notificationCenter: CFNotificationCenter

    init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }

    func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: name.rawValue as CFString), nil, nil, true)
    }
}

enum ScreenShareError: Error {
    case producerDisconnected(reason: String)
    case unknownError
}

open class RtkSampleHandler: RPBroadcastSampleHandler {
    private var clientConnection: BroadcastUploadSocketConnection?
    private var uploader: SampleUploader?

    public var appGroupIdentifier: String? {
        Bundle.main.infoDictionary?["RTKRTCAppGroupIdentifier"] as? String
    }

    public var socketFilePath: String {
        guard let appGroupIdentifier,
              let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
        else {
            return ""
        }

        return sharedContainer.appendingPathComponent("rtc_SSFD").path
    }

    override public init() {
        super.init()
        if printLogs {
            NSLog("ScreenShare SampleHandler Init")
        }
        if let connection = BroadcastUploadSocketConnection(filePath: socketFilePath) {
            clientConnection = connection
            setupConnection()

            uploader = SampleUploader(connection: connection)
        }
    }

    override public func broadcastStarted(withSetupInfo _: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.d
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        if printLogs { NSLog("ScreenShare broadcastStarted for native Kotlin ") }
        openConnection()
    }

    override public func broadcastPaused() {
        if printLogs { NSLog("ScreenShare broadcastPaused for native Kotlin ") }
        DarwinNotificationCenter.shared.postNotification(.broadcastPaused)

        // User has requested to pause the broadcast. Samples will stop being delivered.
    }

    override public func broadcastResumed() {
        if printLogs { NSLog("ScreenShare broadcastResumed for native Kotlin ") }
        DarwinNotificationCenter.shared.postNotification(.broadcastResumed)

        // User has requested to resume the broadcast. Samples delivery will resume.
    }

    override public func broadcastFinished() {
        if printLogs { NSLog("ScreenShare broadcastFinished for native Kotlin ") }

        // User has requested to finish the broadcast.
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        clientConnection?.close()
    }

    override public func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        if printLogs { NSLog("ScreenShare processSampleBuffer ") }
        switch sampleBufferType {
        case RPSampleBufferType.video:
            uploader?.send(sample: sampleBuffer)
        default:
            break
        }
    }

    private func setupConnection() {
        clientConnection?.didClose = { [weak self] error in
            if let error {
                self?.finishBroadcastWithError(error)
            } else {
                // the displayed failure message is more user friendly when using NSError instead of Error
                let RTKScreenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: RTKScreenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped by user"])
                self?.finishBroadcastWithError(customError)
            }
        }
    }

    private func openConnection() {
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            if printLogs { NSLog("ScreenShare openConnection Tried to open connection") }
            guard self?.clientConnection?.open() == true, self?.checkBroadCastIsActive() == true else {
                if printLogs { NSLog("ScreenShare not able to open connection") }

                return
            }
            if printLogs { NSLog("ScreenShare openConnection timer set event") }
            timer.cancel()
        }

        timer.resume()
    }

    func checkBroadCastIsActive() -> Bool {
        if let appGroupID = appGroupIdentifier {
            if let isForcedToStop = UserDefaults(suiteName: appGroupID)?.value(forKey: "ForcedStopBroadCast") as? Bool, isForcedToStop == true {
                UserDefaults(suiteName: appGroupID)?.removeObject(forKey: "ForcedStopBroadCast")
                finishBroadcastWithError(ScreenShareError.producerDisconnected(reason: "Not able to connect to internet"))
                return false
            }
        }
        return true
    }
}
