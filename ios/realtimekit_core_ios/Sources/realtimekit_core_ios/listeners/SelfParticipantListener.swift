import Flutter
import RealtimeKitFlutterCoreKMM

class SelfParticipantEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var eventSinkWrapper: EventSinkWrapper?
    // Live client from the shared holder (rebuilt on rejoin) — always current.
    var rtkClient: RtkClient { RtkClientProvider.shared.client }
    var listener: SelfParticipantListener?
    let plugin: SwiftFlutterCoreIosPlugin

    var defaultSink: FlutterEventSink?

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = SelfParticipantListener(sink: eventSinkWrapper!)
            sendNotification()
        }
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removeSelfEventListener(selfEventListener: _listener)
            eventSinkWrapper = nil
            listener = nil
        }
        sendNotification()
    }

    func sendNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(selfParticipantNotification), object: listener))
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
