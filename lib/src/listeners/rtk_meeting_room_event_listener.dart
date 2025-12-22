import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkMeetingRoomEventListener extends RtkListener {
  void onMeetingInitStarted() {}
  void onMeetingInitCompleted() {}

  /// Here, [error] is of type [MeetingError] a custom error class with params `error` & `details`.
  /// [MeetingError] is a subclass of [Exception].
  /// To use this, type cast `Exception` as `MeetingError` and later on this `Exception` will be replaced by `MeetingError`.
  void onMeetingInitFailed(MeetingError error) {}
  void onMeetingRoomJoinStarted() {}
  void onMeetingRoomJoinCompleted() {}
  void onMeetingRoomJoinFailed(MeetingError error) {}
  void onMeetingRoomLeaveStarted() {}
  void onMeetingRoomLeaveCompleted() {}
  void onMeetingEnded() {}
  void onActiveTabUpdate(ActiveTab? activeTab) {}
  void onSocketConnectionUpdate(SocketConnectionState state) {}
}
