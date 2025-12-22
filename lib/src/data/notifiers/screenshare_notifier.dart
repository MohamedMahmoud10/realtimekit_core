import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteScreenshareNotifier extends Notifier<List<RtkMeetingParticipant>>
    implements RtkDataEventListener {
  @override
  void onScreenShareUpdate(List<RtkRemoteParticipant> screenShares) {
    final List<RtkMeetingParticipant> participants = List.from(screenShares);
    state = participants;
  }

  @override
  List<RtkMeetingParticipant> build() {
    return rtkMeeting.participants.screenshares;
  }

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    RtkMeetingType meetingType,
    RtkDesignTokens designTokens,
  ) {}

  @override
  void onPluginUpdate(List<RtkPlugin> plugin) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}

  @override
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {}
}

class SelfScreenshareNotifier extends Notifier<bool>
    implements RtkSelfEventListener {
  late bool isSelfScreensharing;
  @override
  bool build() {
    isSelfScreensharing = rtkMeeting.participants.screenshares
        .any((peer) => peer.id == rtkMeeting.localUser.id);
    return isSelfScreensharing;
  }

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) {}

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}

  @override
  void onAudioUpdate(bool audioEnabled) {}

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
  void onUpdate(RtkSelfParticipant participant) {}

  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}

  @override
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {
    isSelfScreensharing = isEnabled;
    state = isSelfScreensharing;

    final currentRemoteScreenshares = rtkMeeting.participants.screenshares
        .where((p) => p.id != rtkMeeting.localUser.id)
        .cast<RtkRemoteParticipant>()
        .toList();

    ref
        .read(screenshareProvider.notifier)
        .onScreenShareUpdate(currentRemoteScreenshares);
  }

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}
}

class ScreenshareLimitNotifier extends ValueNotifier<bool>
    implements RtkDataEventListener {
  ScreenshareLimitNotifier()
      : super(rtkMeeting.permissions.userConfig.maxScreenShareCount <=
            rtkMeeting.participants.screenshares.length);

  bool get isLimitReached =>
      rtkMeeting.permissions.userConfig.maxScreenShareCount <=
      rtkMeeting.participants.screenshares.length;

  @override
  void onScreenShareUpdate(List<RtkRemoteParticipant> screenShares) {
    value = isLimitReached;
  }

  @override
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {}

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    RtkMeetingType meetingType,
    RtkDesignTokens designTokens,
  ) {}

  @override
  void onPluginUpdate(List<RtkPlugin> plugin) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}
}
