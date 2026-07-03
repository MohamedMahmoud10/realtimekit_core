import Flutter
import RealtimeKitFlutterCoreKMM

class ChatEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var listener: ChatEventListener?
    var eventSinkWrapper: EventSinkWrapper?
    let rtkClient: RtkClient
    let plugin: SwiftFlutterCoreIosPlugin

    var defaultSink: FlutterEventSink?

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.rtkClient = rtkClient
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = ChatEventListener(sink: eventSinkWrapper!)
            sendNotification()
        }
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removeChatListener(chatEventListener: _listener)
            eventSinkWrapper = nil
            listener = nil
        }
        sendNotification()
    }

    func sendNotification() {
        NotificationCenter.default.post(name: Notification.Name(chatNotification), object: listener)
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
