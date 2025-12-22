import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkSelfEventListener extends RtkListener {
  void onMeetingRoomJoinedWithoutCameraPermission() {}
  void onMeetingRoomJoinedWithoutMicPermission() {}
  void onAudioUpdate(bool isEnabled) {}
  void onVideoUpdate(bool isEnabled) {}
  void onAudioDevicesUpdated(List<AudioDevice> devices) {}
  void onAudioDeviceChanged(AudioDevice audioDevice) {}
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {}
  void onUpdate(RtkSelfParticipant participant) {}
  void onRemovedFromMeeting() {}
  void onVideoDeviceChanged(VideoDevice videoDevice) {}
  void onPermissionsUpdated(SelfPermissions permissions) {}
  void onScreenShareUpdate(bool isEnabled) {}
  void onScreenShareStartFailed(String reason) {}
  void onPinned() {}
  void onUnpinned() {}
}

class LocalUserController extends RtkSelfEventListener {
  RtkSelfParticipant _rtkMeetingParticipant;
  final RtkLocalUserApi _localUserApi;
  final RtkMeetingParticipantApi _meetingParticipantApi;

  LocalUserController(this._localUserApi, this._meetingParticipantApi)
      : _rtkMeetingParticipant = RtkSelfParticipant(
          _localUserApi,
          _meetingParticipantApi,
          id: 'id',
          userId: 'userId',
          name: 'name',
          isHost: false,
          flags: ParticipantFlags(
            hiddenParticipant: false,
            recorder: false,
            webinarHiddenParticipant: false,
          ),
          permissions: SelfPermissions.empty(),
          stageStatus: StageStatus.offStage,
          isCameraPermissionGranted: false,
          isMicrophonePermissionGranted: false,
          presetName: '',
        );
  RtkSelfParticipant get localUser => _rtkMeetingParticipant;

  @override
  void onUpdate(RtkSelfParticipant participant) {
    _rtkMeetingParticipant = RtkSelfParticipant(
      _localUserApi,
      _meetingParticipantApi,
      id: participant.id,
      userId: participant.userId,
      name: participant.name,
      isHost: participant.isHost,
      flags: participant.flags,
      audioEnabled: participant.audioEnabled,
      videoEnabled: participant.videoEnabled,
      screenShareEnabled: participant.screenShareEnabled,
      isPinned: participant.isPinned,
      permissions: participant.permissions,
      stageStatus: participant.stageStatus,
      isCameraPermissionGranted: participant.isCameraPermissionGranted,
      isMicrophonePermissionGranted: participant.isMicrophonePermissionGranted,
      presetName: participant.presetName,
    );
  }

  @override
  void onAudioUpdate(bool isEnabled) {
    _rtkMeetingParticipant.audioEnabled = isEnabled;
  }

  @override
  void onVideoUpdate(bool isEnabled) {
    _rtkMeetingParticipant.videoEnabled = isEnabled;
  }
}
