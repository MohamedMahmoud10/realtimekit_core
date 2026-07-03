import Flutter
import RealtimeKitFlutterCoreKMM

class RoomEventsHandler: NSObject, FlutterStreamHandler, RtkEventsHandler {
    var eventSinkWrapper: EventSinkWrapper?
    var rtkClient: RtkClient
    var listener: RoomEventListener?

    var defaultSink: FlutterEventSink?
    let plugin: SwiftFlutterCoreIosPlugin

    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
        self.rtkClient = rtkClient
        self.plugin = plugin
    }

    func initializeHandler() {
        if let sink = defaultSink {
            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
            listener = RoomEventListener(sink: eventSinkWrapper!, client: rtkClient)
            sendNotification()
        }
    }

    func disposeHandler() {
        if let _listener = listener {
            rtkClient.removeMeetingRoomEventListener(meetingRoomEventListener: _listener)
            eventSinkWrapper = nil
            listener = nil
        }
        sendNotification()
    }

    func sendNotification() {
        NotificationCenter.default.post(name: Notification.Name(meetingRoomNotification), object: listener)
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
