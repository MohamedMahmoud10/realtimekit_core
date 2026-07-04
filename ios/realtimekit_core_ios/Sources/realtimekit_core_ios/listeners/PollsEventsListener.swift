import Flutter
import RealtimeKitFlutterCoreKMM

class PollsEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var eventSinkWrapper: EventSinkWrapper?
    // Live client from the shared holder (rebuilt on rejoin) — always current.
    var rtkClient: RtkClient { RtkClientProvider.shared.client }
    var listener: PollsEventListener?

    var defaultSink: FlutterEventSink?
    let plugin: SwiftFlutterCoreIosPlugin

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = PollsEventListener(sink: eventSinkWrapper!)
            sendNotification()
        }
    }

    func sendNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(pollNotification), object: listener))
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removePollsEventListener(pollEventListener: _listener)
            eventSinkWrapper = nil
            listener = nil
        }
        sendNotification()
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
