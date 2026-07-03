import Flutter
import ReplayKit
import UIKit

import RealtimeKitFlutterCoreKMM

public class SwiftFlutterCoreIosPlugin: NSObject, FlutterPlugin {
    let rtkClientIOS: RtkClient

    var methodChannel: FlutterMethodChannel?
    let participantsEventChannel: FlutterEventChannel
    let roomEventsChannel: FlutterEventChannel
    let chatEventsChannel: FlutterEventChannel
    let selfParticipantChannel: FlutterEventChannel
    let pluginEventsChannel: FlutterEventChannel
    let pollEventsChannel: FlutterEventChannel
    let recordingEventsChannel: FlutterEventChannel
    let waitlistEventsChannel: FlutterEventChannel
    let livestreamEventsChannel: FlutterEventChannel
    let dataEventsChannel: FlutterEventChannel
    let stageEventsChannel: FlutterEventChannel

    var participantsEventsListener: CoreRtkParticipantsEventListener?
    var selfParticipantListener: CoreRtkSelfEventListener?
    var pluginEventsListener: CoreRtkPluginsEventListener?
    var chatEventsListener: CoreRtkChatEventListener?
    var pollEventsListener: CoreRtkPollsEventListener?
    var recordingEventsListener: CoreRtkRecordingEventListener?
    var waitlistEventsListener: CoreRtkWaitlistEventListener?
    var livestreamEventsListener: CoreRtkLivestreamEventListener?
    var dataEventsListener: CoreRtkDataUpdateListener?
    var stageEventsListener: CoreRtkStageEventListener?
    var participantUpdateEventsListener: CoreRtkParticipantUpdateListener?
    var roomEventListener: RoomEventListener?

    // Handler instances
    var roomEventsHandler: RoomEventsHandler?
    var chatEventsHandler: ChatEventsHandler?
    var participantEventsHandler: ParticipantEventsHandler?
    var selfParticipantEventsHandler: SelfParticipantEventsHandler?
    var pluginEventsHandler: PluginEventsHandler?
    var pollsEventsHandler: PollsEventsHandler?
    var recordingEventsHandler: RecordingEventsHandler?
    var waitlistEventsHandler: WaitlistEventsHandler?
//    var livestreamEventsHandler: Li?
    var dataUpdateEventsHandler: DataUpdateEventsHandler?
    var stageEventsHandler: StageEventsHandler?

    init(participantsEventChannel: FlutterEventChannel, roomEventsChannel: FlutterEventChannel, selfParticipantChannel: FlutterEventChannel, pluginEventsChannel: FlutterEventChannel, chatEventsChannel: FlutterEventChannel, pollEventsChannel: FlutterEventChannel, recordingEventsChannel: FlutterEventChannel, waitlistEventsChannel: FlutterEventChannel, livestreamEventsChannel: FlutterEventChannel, stageEventsChannel: FlutterEventChannel, dataEventsChannel: FlutterEventChannel, participantUpdateEventsChannel _: FlutterEventChannel) {
        rtkClientIOS = RtkClientBuilder().build()

        methodChannel = FlutterMethodChannel()
        self.participantsEventChannel = participantsEventChannel
        self.roomEventsChannel = roomEventsChannel
        self.chatEventsChannel = chatEventsChannel
        self.selfParticipantChannel = selfParticipantChannel
        self.pluginEventsChannel = pluginEventsChannel
        self.pollEventsChannel = pollEventsChannel
        self.recordingEventsChannel = recordingEventsChannel
        self.waitlistEventsChannel = waitlistEventsChannel
        self.livestreamEventsChannel = livestreamEventsChannel
        self.dataEventsChannel = dataEventsChannel
        self.stageEventsChannel = stageEventsChannel
    }

    @objc public func getMeetingListener(notification: Notification) {
        roomEventListener = notification.object as! RoomEventListener?
    }

    @objc public func getChatListener(notification: Notification) {
        chatEventsListener = notification.object as! ChatEventListener?
    }

    @objc public func getParticipantEventListener(notification: Notification) {
        participantsEventsListener = notification.object as! ParticipantEventListener?
    }

    @objc public func getSelfEventsListener(notification: Notification) {
        selfParticipantListener = notification.object as! SelfParticipantListener?
    }

    @objc public func getPluginEventsListener(notification: Notification) {
        pluginEventsListener = notification.object as! PluginEventListener?
    }

    @objc public func getPollEventsListener(notification: Notification) {
        pollEventsListener = notification.object as! PollsEventListener?
    }

    @objc public func getRecordingEventsListener(notification: Notification) {
        recordingEventsListener = notification.object as! RecordingEventListener?
    }

    @objc public func getWaitlistEventsListener(notification: Notification) {
        waitlistEventsListener = notification.object as! WaitingRoomEventListener?
    }

    @objc public func getLivestreamEventsListener(notification: Notification) {
        livestreamEventsListener = notification.object as! LivestreamEventListener?
    }

    @objc public func getDataEventsEventsListener(notification: Notification) {
        dataEventsListener = notification.object as! DataUpdateListener?
    }

    @objc public func getStageEventsEventsListener(notification: Notification) {
        stageEventsListener = notification.object as! StageEventListener?
    }

    @objc public func getParticipantUpdateListener(notification: Notification) {
        participantUpdateEventsListener = notification.object as! ParticipantUpdateEventListener?
    }

    func disposeListeners() {
        chatEventsHandler?.disposeHandler()
        dataUpdateEventsHandler?.disposeHandler()
//        livestreamEventsHandler?.disposeHandler()
        participantEventsHandler?.disposeHandler()
        pluginEventsHandler?.disposeHandler()
        pollsEventsHandler?.disposeHandler()
        recordingEventsHandler?.disposeHandler()
        roomEventsHandler?.disposeHandler()
        selfParticipantEventsHandler?.disposeHandler()
        stageEventsHandler?.disposeHandler()
        waitlistEventsHandler?.disposeHandler()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "realtimekit_core_ios", binaryMessenger: registrar.messenger())

        let participantsEventChannel = FlutterEventChannel(name: participantEventChannelName, binaryMessenger: registrar.messenger())

        let meetingRoomEventChannel = FlutterEventChannel(name: meetingRoomEventChannelName, binaryMessenger: registrar.messenger())

        let chatEventChannel = FlutterEventChannel(name: chatsEventChannelName, binaryMessenger: registrar.messenger())

        let selfParticipantChannel = FlutterEventChannel(name: selfParticipantChannelName, binaryMessenger: registrar.messenger())

        let pluginEventsChannel = FlutterEventChannel(name: pluginEventsChannelName, binaryMessenger: registrar.messenger())

        let pollEventsChannel = FlutterEventChannel(name: pollEventsChannelName, binaryMessenger: registrar.messenger())

        let recordingEventsChannel = FlutterEventChannel(name: recordingEventsChannelName, binaryMessenger: registrar.messenger())

        let waitlistEventsChannel = FlutterEventChannel(name: waitlistEventsChannelName, binaryMessenger: registrar.messenger())

        let livestreamEventsChannel = FlutterEventChannel(name: livestreamEventsChannelName, binaryMessenger: registrar.messenger())

        let dataEventsChannel = FlutterEventChannel(name: dataEventsChannelName, binaryMessenger: registrar.messenger())

        let stageEventsChannel = FlutterEventChannel(name: stageEventsChannelName, binaryMessenger: registrar.messenger())

        let participantUpdateEventsChannel = FlutterEventChannel(name: participantUpdateChannelName, binaryMessenger: registrar.messenger())

        let instance = SwiftFlutterCoreIosPlugin(participantsEventChannel: participantsEventChannel, roomEventsChannel: meetingRoomEventChannel, selfParticipantChannel: selfParticipantChannel, pluginEventsChannel: pluginEventsChannel, chatEventsChannel: chatEventChannel, pollEventsChannel: pollEventsChannel, recordingEventsChannel: recordingEventsChannel, waitlistEventsChannel: waitlistEventsChannel, livestreamEventsChannel: livestreamEventsChannel, stageEventsChannel: stageEventsChannel, dataEventsChannel: dataEventsChannel, participantUpdateEventsChannel: participantsEventChannel)

        // Handler instances
        instance.roomEventsHandler = RoomEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.chatEventsHandler = ChatEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.participantEventsHandler = ParticipantEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.selfParticipantEventsHandler = SelfParticipantEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.pluginEventsHandler = PluginEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.pollsEventsHandler = PollsEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.recordingEventsHandler = RecordingEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.waitlistEventsHandler = WaitlistEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
//        instance.livestreamEventsHandler = LivestreamEventsHandler(dyteClient: instance.rtkClientIOS, plugin: instance)
        instance.dataUpdateEventsHandler = DataUpdateEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)
        instance.stageEventsHandler = StageEventsHandler(rtkClient: instance.rtkClientIOS, plugin: instance)

        instance.roomEventsChannel.setStreamHandler(instance.roomEventsHandler)
        instance.chatEventsChannel.setStreamHandler(instance.chatEventsHandler)
        instance.participantsEventChannel.setStreamHandler(instance.participantEventsHandler)
        instance.selfParticipantChannel.setStreamHandler(instance.selfParticipantEventsHandler)
        instance.pluginEventsChannel.setStreamHandler(instance.pluginEventsHandler)
        instance.pollEventsChannel.setStreamHandler(instance.pollsEventsHandler)
        instance.recordingEventsChannel.setStreamHandler(instance.recordingEventsHandler)
        instance.waitlistEventsChannel.setStreamHandler(instance.waitlistEventsHandler)
//        instance.livestreamEventsChannel.setStreamHandler(instance.livestreamEventsHandler)
        instance.dataEventsChannel.setStreamHandler(instance.dataUpdateEventsHandler)
        instance.stageEventsChannel.setStreamHandler(instance.stageEventsHandler)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getMeetingListener(notification:)), name: Notification.Name(meetingRoomNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getChatListener(notification:)), name: Notification.Name(chatNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getParticipantEventListener(notification:)), name: Notification.Name(participantNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getSelfEventsListener(notification:)), name: Notification.Name(selfParticipantNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getPluginEventsListener(notification:)), name: Notification.Name(pluginNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getPollEventsListener(notification:)), name: Notification.Name(pollNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getRecordingEventsListener(notification:)), name: Notification.Name(recordingNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getWaitlistEventsListener(notification:)), name: Notification.Name(waitlistNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getLivestreamEventsListener(notification:)), name: Notification.Name(livestreamNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getStageEventsEventsListener(notification:)), name: Notification.Name(stageNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getDataEventsEventsListener(notification:)), name: Notification.Name(dataUpdateNotification), object: nil)

        NotificationCenter.default.addObserver(instance, selector: #selector(instance.getParticipantUpdateListener(notification:)), name: Notification.Name(participantUpdateNotification), object: nil)

        let mobileClient = instance.rtkClientIOS.core

        let videoViewFactory = RtkVideoViewFactory(messenger: registrar.messenger(), client: mobileClient)
        let pluginViewFactory = RtkPluginViewFactory(client: mobileClient)
        let screenshareViewFactory = RtkScreenshareViewFactory(client: mobileClient)
//        let lvsViewFactory = DyteLivestreamViewFactory()

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(videoViewFactory, withId: "DytePlatformVideoView")
        registrar.register(pluginViewFactory, withId: "DytePlatformPluginView")
        registrar.register(screenshareViewFactory, withId: "DytePlatformScreenshareView")
//        registrar.register(lvsViewFactory, withId: "DytePlatformLivestreamView")
        registrar.addApplicationDelegate(instance)
    }

    private func fileURL(from path: String) -> URL {
        return path.hasPrefix("file://")
            ? URL(string: path)!
            : URL(fileURLWithPath: path)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let meetingInfo = CoreRtkMeetingInfo.companion.fromMap(map: call.arguments as! [String: Any])
            rtkClientIOS.doInit(meetingInfo: meetingInfo) {
                result(nil)
            } onError: { error in
                result(error?.code.rawValue)
            }

        case "disableCache":
            rtkClientIOS.disableCache()
            return result(nil)

        case "enableCache":
            rtkClientIOS.enableCache()
            return result(nil)

        case "joinRoom":
            rtkClientIOS.joinRoom {
                result(nil)
            } onError: { error in
                result(error?.code.rawValue)
            }

        case "leaveRoom":
            rtkClientIOS.leaveRoom {
                result(nil)
            } onError: { error in
                result(error?.code.rawValue)
            }

        case "addMeetingRoomEventListener":
            if roomEventListener == nil {
                roomEventsHandler?.initializeHandler()
            }
            if let listner = roomEventListener {
                rtkClientIOS.addMeetingRoomEventListener(meetingRoomEventListener: listner as CoreRtkMeetingRoomEventListener)
            }
            return result(nil)

        case "removeMeetingRoomEventsListener":
            if let listner = roomEventListener {
                rtkClientIOS.removeMeetingRoomEventListener(meetingRoomEventListener: listner)
                roomEventListener = nil
            }
            return result(nil)

        case "addChatListener":
            if chatEventsListener == nil {
                chatEventsHandler?.initializeHandler()
            }
            if let listener = chatEventsListener {
                rtkClientIOS.addChatListener(chatEventListener: listener)
            }
            return result(nil)

        case "removeChatListener":
            if let listener = chatEventsListener {
                rtkClientIOS.removeChatListener(chatEventListener: listener)
                chatEventsListener = nil
            }
            return result(nil)

        case "addParticipantsEventListener":
            if participantsEventsListener == nil {
                participantEventsHandler?.initializeHandler()
            }
            if let listener = participantsEventsListener {
                rtkClientIOS.addParticipantsEventListener(participantEventListener: listener)
            }
            return result(nil)

        case "removeParticipantEventListener":
            if let listener = participantsEventsListener {
                rtkClientIOS.removeParticipantsEventListener(participantEventListener: listener)
                participantsEventsListener = nil
            }
            return result(nil)

        case "addParticipantUpdateListener":
            if let listener = participantUpdateEventsListener {
                let participantId = call.arguments as? String
                let participants = rtkClientIOS.core.participants
                var allParticipants: [CoreRtkMeetingParticipant] = []
                allParticipants.append(contentsOf: participants.waitlisted)
                allParticipants.append(contentsOf: participants.joined)
                allParticipants.append(contentsOf: participants.screenShares)

                if let participant = allParticipants.first(where: {
                    $0.id == participantId
                }) {
                    rtkClientIOS.addParticipantUpdateListener(participant: participant, participantUpdateListener: listener)
                } else {
                    return result(FlutterError(code: "participant-not-found", message: "Participant with participant ID \(String(describing: participantId)) not found", details: ""))
                }
            }
            return result(nil)

        case "removeParticipantUpdateListener":
            if let listener = participantUpdateEventsListener {
                let participantId = call.arguments as? String
                let participants = rtkClientIOS.core.participants
                var allParticipants: [CoreRtkMeetingParticipant] = []
                allParticipants.append(contentsOf: participants.waitlisted)
                allParticipants.append(contentsOf: participants.joined)
                allParticipants.append(contentsOf: participants.screenShares)

                if let participant = allParticipants.first(where: {
                    $0.id == participantId
                }) {
                    rtkClientIOS.removeParticipantUpdateListener(participant: participant, participantUpdateListener: listener)
                } else {
                    return result(FlutterError(code: "participant-not-found", message: "Participant with participant ID \(String(describing: participantId)) not found", details: ""))
                }
            }
            return result(nil)

        case "removeParticipantUpdateListeners":
            if let listener = participantUpdateEventsListener {
                let participantId = call.arguments as? String
                let participants = rtkClientIOS.core.participants
                var allParticipants: [CoreRtkMeetingParticipant] = []
                allParticipants.append(contentsOf: participants.waitlisted)
                allParticipants.append(contentsOf: participants.joined)
                allParticipants.append(contentsOf: participants.screenShares)

                if let participant = allParticipants.first(where: {
                    $0.id == participantId
                }) {
                    rtkClientIOS.removeParticipantUpdateListeners(participant: participant)
                } else {
                    return result(FlutterError(code: "participant-not-found", message: "Participant with participant ID \(String(describing: participantId)) not found", details: ""))
                }
            }
            return result(nil)

        case "addSelfParticipantEventListener":
            if selfParticipantListener == nil {
                selfParticipantEventsHandler?.initializeHandler()
            }
            if let listener = selfParticipantListener {
                rtkClientIOS.addSelfEventListener(selfEventListener: listener)
            }
            return result(nil)

        case "removeSelfParticipantEventListener":
            if let listener = selfParticipantListener {
                rtkClientIOS.removeSelfEventListener(selfEventListener: listener)
                selfParticipantListener = nil
            }
            return result(nil)

        case "addPluginEventListener":
            if pluginEventsListener == nil {
                pluginEventsHandler?.initializeHandler()
            }
            if let listener = pluginEventsListener {
                rtkClientIOS.addPluginEventListener(pluginEventListener: listener)
            }
            return result(nil)

        case "removePluginEventsListener":
            if let listener = pluginEventsListener {
                rtkClientIOS.removePluginEventListener(pluginEventListener: listener)
                pluginEventsListener = nil
            }
            return result(nil)

        case "addPollsEventListener":
            if pollEventsListener == nil {
                pollsEventsHandler?.initializeHandler()
            }
            if let listener = pollEventsListener {
                rtkClientIOS.addPollsEventListener(pollEventListener: listener)
            }
            return result(nil)

        case "removePollsEventsListener":
            if let listener = pollEventsListener {
                rtkClientIOS.removePollsEventListener(pollEventListener: listener)
                pollEventsListener = nil
            }
            return result(nil)

        case "addDataUpdateListener":
            if dataEventsListener == nil {
                dataUpdateEventsHandler?.initializeHandler()
            }
            if let listener = dataEventsListener {
                rtkClientIOS.addDataUpdateListener(dataUpdateListener: listener)
            }
            return result(nil)

        case "removeDataUpdateListener":
            if let listener = dataEventsListener {
                rtkClientIOS.removeDataUpdateListener(dataUpdateListener: listener)
                dataEventsListener = nil
            }
            return result(nil)

        case "addRecordingEventListener":
            if recordingEventsListener == nil {
                recordingEventsHandler?.initializeHandler()
            }
            if let listener = recordingEventsListener {
                rtkClientIOS.addRecordingEventListener(recordingEventListener: listener)
            }
            return result(nil)

        case "removeRecordingEventsListener":
            if let listener = recordingEventsListener {
                rtkClientIOS.removeRecordingEventListener(recordingEventListener: listener)
                recordingEventsListener = nil
            }
            return result(nil)

        case "addWaitingRoomEventListener":
            if waitlistEventsListener == nil {
                waitlistEventsHandler?.initializeHandler()
            }
            if let listener = waitlistEventsListener {
                rtkClientIOS.addWaitlistEventListener(waitlistEventListener: listener)
            }
            return result(nil)

        case "removeWaitingRoomEventsListener":
            if let listener = waitlistEventsListener {
                rtkClientIOS.removeWaitlistEventListener(waitlistEventListener: listener)
                waitlistEventsListener = nil
            }
            return result(nil)

        case "addLivestreamEventsListener":
//            if(self.livestreamEventsListener==nil){
//                livestreamEventsHandler?.initializeHandler()
//            }
//            if let listener = self.livestreamEventsListener{
//                rtkClientIOS.addlivestreamEventListener(livestreamEventsListener: listener)
//            }
            return result(nil)

        case "removeLivestreamEventsListener":
//            if let listener = self.livestreamEventsListener{
//                rtkClientIOS.removelivestreamEventsListener(livestreamEventsListener: listener)
//                self.livestreamEventsListener = nil
//            }
            return result(nil)

        case "addStageEventListener":
            if stageEventsListener == nil {
                stageEventsHandler?.initializeHandler()
            }
            if let listener = stageEventsListener {
                rtkClientIOS.addStageEventListener(stageEventListener: listener)
            }
            return result(nil)

        case "removeStageEventsListener":
            if let listener = stageEventsListener {
                rtkClientIOS.removeStageEventListener(stageEventListener: listener)
                stageEventsListener = nil
            }
            return result(nil)

        case "participants":
            result(rtkClientIOS.participants().toMap())

        case "enableVideo":
            rtkClientIOS.enableVideo(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "disableVideo":
            rtkClientIOS.disableVideo(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "enableAudio":
            return rtkClientIOS.enableAudio(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "disableAudio":
            return rtkClientIOS.disableAudio(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "meta":
            let meta = rtkClientIOS.getMetaData()
            return result(meta)

        case "sendTextMessage":
            do {
                try rtkClientIOS.sendTextMessage(text: (call.arguments as? String) ?? "")
                return result(nil)
            } catch {
                return result(error)
            }

        case "sendFileMessage":
            let messageInfo = (call.arguments as? [String: Any?]) ?? [:]
            let filePath = (messageInfo["path"] as? String) ?? ""
            let uri = CoreRtkUri(inner: fileURL(from: filePath))
            rtkClientIOS.sendFileMessage(uri: uri) { error in
                if let err = error {
                    result(err.code.rawValue)
                } else {
                    result(nil)
                }
            }

        case "sendImageMessage":
            let messageInfo = (call.arguments as? [String: Any?]) ?? [:]
            let filePath = (messageInfo["path"] as? String) ?? ""
            let uri = CoreRtkUri(inner: fileURL(from: filePath))
            rtkClientIOS.sendImageMessage(uri: uri) { error in
                if let err = error {
                    result(err.code.rawValue)
                } else {
                    result(nil)
                }
            }

        case "downloadAttachment":
            let attachmentInfo = (call.arguments as? [String: Any?]) ?? [:]
            let url = URL(string: attachmentInfo["url"] as! String)
            let fileName = attachmentInfo["fileName"] as! String
            ChatFileDownloader.enqueue(documentURL: url!, fileName: fileName)
            return result(nil)

        case "setDisplayName":
            let displayName = (call.arguments as? String) ?? ""
            rtkClientIOS.setDisplayName(name: displayName)
            return result(nil)

        case "getAudioDevices":
            let audioDevice = rtkClientIOS.getAudioDevices()
            return result(audioDevice.map { dev in dev.toMap() })

        case "getVideoDevices":
            let videoDevice = rtkClientIOS.getVideoDevices()
            result(videoDevice.map { dev in dev.toMap() })

        case "setAudioDevice":
            let map = (call.arguments as? [String: Any?]) ?? [:]
            let audioDevice = CoreAudioDevice.companion.fromMap(map: map as [String: Any])
            // TODO: fix this.
            rtkClientIOS.setAudioDevice(audioDevice: audioDevice)
            return result(nil)

        case "setVideoDevice":
            let map = (call.arguments as? [String: Any?]) ?? [:]
            let videoDevice = CoreVideoDevice.companion.fromMap(map: map as [String: Any])
            rtkClientIOS.setVideoDevice(videoDevice: videoDevice)
            return result(nil)

        case "getSelectedVideoDevice":
            let selectedVideoDevice = rtkClientIOS.getSelectedVideoDevice()
            return result(selectedVideoDevice?.toMap())

        case "getSelectedAudioDevice":
            let selectedAudioDevice = rtkClientIOS.getSelectedAudioDevice()
            return result(selectedAudioDevice?.toMap())

        case "switchCamera":
            rtkClientIOS.switchCamera()
            return result(nil)

        case "createPoll":
            let pollChars = (call.arguments as? [String: Any?]) ?? [:]
            rtkClientIOS.createPoll(pollChars: pollChars)
            return result(nil)

        case "votePoll":
            let pollVote = (call.arguments as? [String: Any?]) ?? [:]
            rtkClientIOS.voteOnPoll(pollVote: pollVote)
            return result(nil)

        case "startRecording":
            return rtkClientIOS.startRecording(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "stopRecording":
            return rtkClientIOS.stopRecording(onResult: { (error: (any CoreRtkError)?) in
                result(error?.code.rawValue)
            })

        case "getRecordingState":
            let state = rtkClientIOS.getRecordingState()
            let recordingState = state.toMap()["state"]
            return result(recordingState)

        case "setPage":
            let currentPage = (call.arguments as? Int) ?? 0
            do {
                try rtkClientIOS.setPage(pageNumber: Int32(currentPage))
                return result(nil)
            } catch {
                return result(FlutterError(code: "set-page", message: error.localizedDescription, details: nil))
            }

        case "getActivePlugins":
            let activePlugin: [[String: Any?]] = rtkClientIOS.getActivePlugins()
            return result(activePlugin)

        case "activatePlugin":
            if let pluginId = call.arguments as? String {
                rtkClientIOS.activatePlugin(pluginId: pluginId)
            }
            return result(nil)

        case "deactivatePlugin":
            if let pluginId = call.arguments as? String {
                rtkClientIOS.deactivatePlugin(pluginId: pluginId)
            }
            return result(nil)

        case "pinParticipant":
            let participantId = call.arguments as! String
            do {
                try rtkClientIOS.pinParticipant(participantId: participantId)
                return result(nil)
            } catch {
                return result(FlutterError(code: "pin-participant", message: error.localizedDescription, details: nil))
            }

        case "unpinParticipant":
            do {
                try rtkClientIOS.unpinParticipant()
                return result(nil)
            } catch {
                return result(FlutterError(code: "unpin-participant", message: error.localizedDescription, details: nil))
            }

        case "getPermissions":
            //            TODO: Fix this
            //            let permissions : [String:Any] = rtkClientIOS.getPermissions();
            return result(nil)

        case "disableParticipantAudio":
            guard let participantId = call.arguments as? String else {
                return result(FlutterError(code: "INVALID_ARGUMENT",
                                           message: "Participant ID must be a String.",
                                           details: nil))
            }

            if let error = rtkClientIOS.disableParticipantAudio(participantId: participantId) {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "disableAllAudio":
            if let error = rtkClientIOS.disableAllAudio() {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "disableParticipantVideo":
            guard let participantId = call.arguments as? String else {
                return result(FlutterError(code: "INVALID_ARGUMENT",
                                           message: "Participant ID must be a String.",
                                           details: nil))
            }

            if let error = rtkClientIOS.disableParticipantVideo(participantId: participantId) {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "disableAllVideo":
            if let error = rtkClientIOS.disableAllVideo() {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "kickParticipant":
            guard let participantId = call.arguments as? String else {
                return result(FlutterError(code: "INVALID_ARGUMENT",
                                           message: "Participant ID must be a String.",
                                           details: nil))
            }

            if let error = rtkClientIOS.kickParticipant(participantId: participantId) {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "kickAll":
            if let error = rtkClientIOS.kickAll() {
                return result(FlutterError(code: String(error.code.rawValue),
                                           message: error.message,
                                           details: nil))
            } else {
                return result(nil)
            }

        case "acceptWaitListedRequest":
            if let participantId = call.arguments as? String {
                do {
                    try rtkClientIOS.acceptWaitingRoomRequest(participantId: participantId)
                    return result(nil)
                } catch {
                    return result(FlutterError(code: "accept-waitlisted-request", message: error.localizedDescription, details: nil))
                }
            }
            return result(nil)

        case "acceptAllWaitingRoomRequests":
            rtkClientIOS.acceptAllWaitingRoomRequests()
            return result(nil)

        case "rejectWaitListedRequest":
            if let participantId = call.arguments as? String {
                do {
                    try rtkClientIOS.rejectWaitingRoomRequest(participantId: participantId)
                    return result(nil)
                } catch {
                    return result(FlutterError(code: "reject-waitlisted-request", message: error.localizedDescription, details: nil))
                }
            }
            return result(nil)

        case "requestStageAccess":
            rtkClientIOS.requestToJoinStage()
            return result(nil)

        case "cancelRequestAccess":
            rtkClientIOS.withdrawJoinStageRequest()
            return result(nil)

        case "grantAccessToStage":
            if let participantIds = call.arguments as? [String] {
                rtkClientIOS.grantAccessToStage(peerIds: participantIds)
                return result(nil)
            } else {
                return result(FlutterError(code: "grant-access-to-stage", message: "Pass valid participant", details: nil))
            }

        case "denyAccessToStage":
            if let participantIds = call.arguments as? [String] {
                rtkClientIOS.denyAccessToStage(peerIds: participantIds)
                return result(nil)
            } else {
                return result(FlutterError(code: "deny-access-to-stage", message: "Pass valid participant", details: nil))
            }

        case "joinStage":
            rtkClientIOS.joinStage()
            return result(nil)

        case "leaveStage":
            rtkClientIOS.leaveStage()
            return result(nil)

        case "kickPeerFromStage":
            if let participantIds = call.arguments as? [String] {
                rtkClientIOS.kickPeerFromStage(participantIds: participantIds)
                return result(nil)
            } else {
                return result(FlutterError(code: "kick-peer-from-stage", message: "Pass valid participant", details: nil))
            }

        case "goLive":
            rtkClientIOS.startLvs()

        case "stopLive":
            rtkClientIOS.stopLvs()

        case "getLivestreamState":
            let state = rtkClientIOS.getStreamState()
            return result(state)

        case "getLivestreamUrl":
            let url = rtkClientIOS.getStreamUrl()
            return result(url)

//        case "getLivestreamRoomName":
//            let roomName = rtkClientIOS.getStreamRoomName()
//            return result(roomName)

        case "launchUrl":
            let url = call.arguments as? String
            if url == nil {
                return result(false)
            } else {
                let canLaunch = RtkUtils().launchUrl(context: nil, url: url!)
                if canLaunch {
                    return result(true)
                } else {
                    return result(false)
                }
            }

        case "enableScreenshare":
            rtkClientIOS.enableScreenShare()
            return result(nil)

        case "disableScreenshare":
            rtkClientIOS.disableScreenShare()
            return result(nil)

        case "broadcastMessage":
            if let args = (call.arguments as? [String: Any]), let type = args["type"] as? String, let payload = args["payload"] as? [String: Any] {
                rtkClientIOS.broadcastMessage(type: type, payload: payload)
                return result(nil)
            } else {
                return result(FlutterError(code: "broadcast-message-failed", message: "wrong-params-passed", details: nil))
            }

        case "release":
            rtkClientIOS.releaseMeeting(onReleaseSuccess: {
                self.disposeListeners(); result(true)
            }, onReleaseFailed: { _ in
                result(false)
            })

        case "getSelfActiveTab":
            result(rtkClientIOS.getSelfActiveTab())

        case "syncTab":
            if let args = (call.arguments as? [String: Any]), let id = args["id"] as? String, let type = args["type"] as? String {
                guard let activeTab = CoreActiveTabType.entries.first(where: { tabType in
                    tabType.name == type
                }) else {
                    return result(FlutterError(code: "syncTab-failed", message: "invalid-plugin-passed", details: nil))
                }
                rtkClientIOS.tabSync(id: id, tab: activeTab)
                return result(nil)
            }

        case "logSdkVersion":
            if let args = (call.arguments as? [String: Any]), let sdkName = args["sdkName"] as? String,
               let version = args["version"] as? String

            {
                rtkClientIOS.setUiKitInfo(name: sdkName, version: version)
            }
            return result(nil)

        default:
            print("Not implemented: \(call.method)")
            return result(nil)
        }
    }
}
