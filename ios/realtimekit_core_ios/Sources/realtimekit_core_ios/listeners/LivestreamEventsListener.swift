import Flutter
import RealtimeKitFlutterCoreKMM

//
//
// class LivestreamEventsHandler : NSObject, FlutterStreamHandler, RtkEventsHandler {
//
//    var eventSinkWrapper: EventSinkWrapper?
//    var rtkClient: RtkClient
//    var listener: LivestreamEventsListener?
//
//    var defaultSink: FlutterEventSink?
//    let plugin: SwiftFlutterCoreIosPlugin
//
//
//    init(rtkClient: RtkClient, plugin: SwiftFlutterCoreIosPlugin) {
//        self.rtkClient = rtkClient
//        self.plugin = plugin
//    }
//
//    func initializeHandler(){
//        if let sink = defaultSink{
//            eventSinkWrapper = EventSinkWrapper(sink: sink, plugin: plugin)
//            listener = LivestreamEventsListener(sink: eventSinkWrapper!)
//            sendNotification()
//        }
//    }
//    func disposeHandler(){
//        if let _listener = listener {
//            rtkClient.removeLivestreamEventsListener(livestreamEventsListener: _listener)
//            eventSinkWrapper = nil
//            listener = nil
//        }
//        sendNotification()
//    }
//
//    func sendNotification(){
//        NotificationCenter.default.post(Notification(name: Notification.Name(livestreamNotification), object: listener))
//    }
//
//
//    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        defaultSink = events
//        initializeHandler()
//
//        return nil
//    }
//
//    func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        disposeHandler()
//        return nil;
//    }
// }
