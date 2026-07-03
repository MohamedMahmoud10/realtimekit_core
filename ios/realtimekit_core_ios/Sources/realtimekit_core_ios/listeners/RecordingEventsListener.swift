import Flutter
import RealtimeKitFlutterCoreKMM

class RecordingEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var eventSinkWrapper: EventSinkWrapper?
    var rtkClient: RtkClient
    var listener: RecordingEventListener?

    var defaultSink: FlutterEventSink?
    let plugin: SwiftFlutterCoreIosPlugin

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.rtkClient = rtkClient
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = RecordingEventListener(sink: eventSinkWrapper!)
            sendNotification()
        }
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removeRecordingEventListener(recordingEventListener: _listener)
            eventSinkWrapper = nil
            listener = nil
        }
        sendNotification()
    }

    func sendNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(recordingNotification), object: listener))
    }

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        defaultSink = events
        initializeHandler()
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        disposeHandler()
        return nil
    }
}
