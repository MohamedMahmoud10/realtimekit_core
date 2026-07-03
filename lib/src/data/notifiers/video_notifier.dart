import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class LocalUserVideoNotifier extends ValueNotifier<bool>
    implements RtkSelfEventListener {
  LocalUserVideoNotifier() : super(rtkMeeting.localUser.videoEnabled);

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}

  @override
  void onVideoUpdate(bool videoEnabled) {
    value = videoEnabled;
  }

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) {}

  @override
  void onAudioUpdate(bool audioEnabled) {}

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}

  @override
  void onRemovedFromMeeting() {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onUpdate(RtkSelfParticipant participant) {}

  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}

  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {}

  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}
}

class VideoNotifier extends ValueNotifier<bool>
    implements RtkParticipantsEventListener {
  RtkMeetingParticipant participant;
  VideoNotifier(this.participant) : super(participant.videoEnabled);

  @override
  void onVideoUpdate(RtkMeetingParticipant participant, bool isEnabled) {
    if (participant.id == this.participant.id) {
      value = isEnabled;
    }
  }

  @override
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {}

  @override
  void onActiveSpeakerChanged(RtkRemoteParticipant? participant) {}

  @override
  void onAudioUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onParticipantJoin(RtkRemoteParticipant participant) {}

  @override
  void onParticipantLeave(RtkRemoteParticipant participant) {}

  @override
  void onParticipantPinned(RtkRemoteParticipant participant) {}

  @override
  void onParticipantUnpinned(RtkRemoteParticipant participant) {}

  @override
  void onUpdate(RtkParticipants participants) {}

  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {
    // TODO: implement onNewBroadcastMessage
  }

  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    // TODO: implement onScreenShareUpdate
  }
}
