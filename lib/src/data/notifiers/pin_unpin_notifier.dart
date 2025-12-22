import 'package:flutter/material.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class PinNotifier extends ValueNotifier<RtkMeetingParticipant?> {
  late final _ParticipantsListener _participantsListener;
  late final _SelfListener _selfListener;

  PinNotifier() : super(rtkMeeting.participants.pinned) {
    _participantsListener = _ParticipantsListener(this);
    _selfListener = _SelfListener(this);

    rtkMeeting.addParticipantsEventListener(_participantsListener);
    rtkMeeting.addSelfEventListener(_selfListener);
  }

  void handleParticipantPinned(RtkRemoteParticipant participant) {
    value = participant;
  }

  void handleParticipantUnpinned() {
    value = null;
  }

  void handleSelfPinned() {
    value = rtkMeeting.localUser;
  }

  void handleSelfUnpinned() {
    value = null;
  }

  @override
  void dispose() {
    rtkMeeting.removeParticipantsEventListener(_participantsListener);
    rtkMeeting.removeSelfEventListener(_selfListener);
    super.dispose();
  }
}

class _ParticipantsListener implements RtkParticipantsEventListener {
  final PinNotifier _notifier;
  _ParticipantsListener(this._notifier);

  @override
  void onParticipantPinned(RtkRemoteParticipant participant) {
    _notifier.handleParticipantPinned(participant);
  }

  @override
  void onParticipantUnpinned(RtkRemoteParticipant participant) {
    _notifier.handleParticipantUnpinned();
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
  void onUpdate(RtkParticipants participants) {}
  @override
  void onVideoUpdate(RtkRemoteParticipant participant, bool isEnabled) {}
  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {}
  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {}
}

class _SelfListener implements RtkSelfEventListener {
  final PinNotifier _notifier;
  _SelfListener(this._notifier);

  @override
  void onPinned() {
    _notifier.handleSelfPinned();
  }

  @override
  void onUnpinned() {
    _notifier.handleSelfUnpinned();
  }

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) {}
  @override
  void onAudioUpdate(bool isEnabled) {}
  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}
  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}
  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}
  @override
  void onRemovedFromMeeting() {}
  @override
  void onScreenShareStartFailed(String reason) {}
  @override
  void onScreenShareUpdate(bool isEnabled) {}
  @override
  void onUpdate(RtkSelfParticipant participant) {}
  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}
  @override
  void onVideoUpdate(bool isEnabled) {}
  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {}
  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}
}
