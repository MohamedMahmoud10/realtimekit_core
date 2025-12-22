enum RtkRoomEventName {
  onMeetingInitStarted("onMeetingInitStarted"),
  onMeetingInitFailed("onMeetingInitFailed"),
  onMeetingInitCompleted("onMeetingInitCompleted"),
  onMeetingRoomJoinStarted("onMeetingRoomJoinStarted"),
  onMeetingRoomJoinCompleted("onMeetingRoomJoinCompleted"),
  onMeetingRoomJoinFailed("onMeetingRoomJoinFailed"),
  onMeetingRoomLeaveCompleted("onMeetingRoomLeaveCompleted"),
  onMeetingRoomLeaveStarted("onMeetingRoomLeaveStarted"),
  onMeetingEnded('onMeetingEnded'),
  onActiveTabUpdate('onActiveTabUpdate'),
  onSocketConnectionUpdate('onSocketConnectionUpdate'),
  unknown("unknown");

  final String name;
  const RtkRoomEventName(this.name);

  static RtkRoomEventName fromString(String name) {
    return RtkRoomEventName.values.firstWhere(
      (event) => event.name == name,
      orElse: () => RtkRoomEventName.unknown,
    );
  }

  static RtkRoomEventName fromName(String name) {
    for (RtkRoomEventName event in values) {
      if (event.name == name) {
        return event;
      }
    }
    return RtkRoomEventName.unknown;
  }
}
