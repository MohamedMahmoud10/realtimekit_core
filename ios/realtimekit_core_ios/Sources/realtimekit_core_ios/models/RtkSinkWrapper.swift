import Flutter
import Foundation
import RealtimeKitFlutterCoreKMM

class EventSinkWrapper: RtkSink {
    let sink: FlutterEventSink
    let plugin: SwiftFlutterCoreIosPlugin

    init(sink: @escaping FlutterEventSink, plugin: SwiftFlutterCoreIosPlugin) {
        self.sink = sink
        self.plugin = plugin
    }

    func error(errorCode _: String, errorMessage _: String?, errorDetails _: Any?) {}

    private func disposeListeners() {
        plugin.disposeListeners()
    }

    func success(result: Any?) {
        let eventName = (result as! [String: Any?])["name"] as! String
        if DyteEvents.exitingEvents.contains(eventName) {
            disposeListeners()
            sink(result)
        } else {
            sink(result)
        }
    }
}

class DyteEvents {
    static var onMeetingLeaveCompleted: String = "onMeetingRoomLeaveCompleted"
    static var onRemovedFromMeeting: String = "onRemovedFromMeeting"
    static var onMeetingInitFailed: String = "onMeetingInitFailed"
    static var onMeetingEnded: String = "onMeetingEnded"

    static var exitingEvents: Set = [DyteEvents.onMeetingEnded, DyteEvents.onMeetingInitFailed, DyteEvents.onMeetingLeaveCompleted, DyteEvents.onRemovedFromMeeting]
}
