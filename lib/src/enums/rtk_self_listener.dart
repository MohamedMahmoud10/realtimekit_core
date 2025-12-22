enum RtkSelfListenerMethodNames {
  onMeetingRoomJoinedWithoutCameraPermission(
      "onMeetingRoomJoinedWithoutCameraPermission"),
  onMeetingRoomJoinedWithoutMicPermission(
      "onMeetingRoomJoinedWithoutMicPermission"),
  onAudioUpdate("onAudioUpdate"),
  onVideoUpdate("onVideoUpdate"),
  onAudioDevicesUpdated("onAudioDevicesUpdated"),
  onAudioDeviceChanged("onAudioDeviceChanged"),
  onVideoDeviceChanged("onVideoDeviceChanged"),
  onWaitListStatusUpdate("onWaitListStatusUpdate"),
  onUpdate("onUpdate"),
  onRemovedFromMeeting("onRemovedFromMeeting"),
  onScreenShareUpdate("onScreenShareUpdate"),
  onScreenShareStartFailed("onScreenShareStartFailed"),
  onPermissionsUpdated('onPermissionsUpdated'),
  onPinned("onPinned"),
  onUnpinned("onUnpinned"),
  unknown("unknown");

  final String name;
  const RtkSelfListenerMethodNames(this.name);

  static RtkSelfListenerMethodNames fromName(String name) {
    return RtkSelfListenerMethodNames.values.firstWhere(
      (element) => element.name == name,
      orElse: () => RtkSelfListenerMethodNames.unknown,
    );
  }
}
