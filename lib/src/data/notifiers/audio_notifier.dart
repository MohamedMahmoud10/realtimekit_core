import 'dart:developer';

import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class LocalUserAudioNotifier extends ValueNotifier<bool>
    implements RtkSelfEventListener {
  LocalUserAudioNotifier() : super(rtkMeeting.localUser.audioEnabled);

  @override
  void onAudioUpdate(bool audioEnabled) {
    value = audioEnabled;
  }

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) {
    log('audioDevice Updated: $audioDevices');
  }

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {
    log('audioDevice Changed: $audioDevice');
  }

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
  void onVideoUpdate(bool videoEnabled) {}

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

class AudioNotifier extends ValueNotifier<bool>
    implements RtkParticipantsEventListener {
  AudioNotifier(this.participant) : super(participant.audioEnabled);

  final RtkMeetingParticipant participant;

  @override
  void onAudioUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    if (participant.userId == this.participant.userId) {
      value = isEnabled;
    }
  }

  @override
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {}

  @override
  void onActiveSpeakerChanged(RtkRemoteParticipant? participant) {}

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
  void onVideoUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {
    // TODO: implement onNewBroadcastMessage
  }

  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    // TODO: implement onScreenShareUpdate
  }
}
