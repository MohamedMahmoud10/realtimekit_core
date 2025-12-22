import 'package:realtimekit_core/realtimekit_core.dart';

class OnRouterMeetingInitCompleted extends RouterStates {}

class OnRouterMeetingInitFailed extends RouterStates {
  final MeetingError error;
  OnRouterMeetingInitFailed(this.error);
}

class OnRouterMeetingInitStarted extends RouterStates {}

class OnRouterMeetingRoomDisconnected extends RouterStates {}

class OnRouterMeetingRoomJoinCompleted extends RouterStates {}

class OnRouterMeetingRoomReconnecting extends RouterStates {}

class OnRouterMeetingRoomReconnected extends RouterStates {}

class OnRouterMeetingRoomReconnectionFailed extends RouterStates {}

class OnRouterMeetingRoomJoinFailed extends RouterStates {
  final MeetingError error;
  OnRouterMeetingRoomJoinFailed(this.error);
}

class OnRouterMeetingRoomJoinStarted extends RouterStates {}

class OnRouterMeetingRoomLeaveCompleted extends RouterStates {}

class OnRouterMeetingRoomLeaveStarted extends RouterStates {}

class OnRouterRemovedFromMeeting extends RouterStates {}

class OnRouterMeetingEnded extends RouterStates {}

class OnRouterSelfWaitingRoomStatusUpdate extends RouterStates {
  final WaitlistStatus waitListStatus;
  OnRouterSelfWaitingRoomStatusUpdate(this.waitListStatus);
}

class RouterInitial extends RouterStates {}

abstract class RouterStates {}
