import Flutter
import RealtimeKitFlutterCoreKMM

class PluginEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var eventSinkWrapper: EventSinkWrapper?
    var rtkClient: RtkClient
    var listener: PluginEventListener?

    var defaultSink: FlutterEventSink?

    let plugin: SwiftFlutterCoreIosPlugin

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.rtkClient = rtkClient
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = PluginEventListener(sink: eventSinkWrapper!)
            sendNotification()
        }
    }

    func sendNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(pluginNotification), object: listener))
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removePluginEventListener(pluginEventListener: _listener)
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
