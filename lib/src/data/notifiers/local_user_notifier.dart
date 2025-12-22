import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/local_user_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalUserNotifer extends Notifier<LocalUserStates>
    implements RtkSelfEventListener {
  LocalUserNotifer() : super();

  bool isVideoEnabled = false;

  bool isAudioEnabled = false;

  @override
  LocalUserStates build() {
    isVideoEnabled = meetingInfo.enableVideo;
    isAudioEnabled = meetingInfo.enableAudio;
    return LocalUserStateInitial();
  }

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) =>
      state = OnAudioDevicesUpdated(audioDevices);

  @override
  void onUpdate(RtkSelfParticipant participant) =>
      state = OnUpdate(participant);

  @override
  void onVideoUpdate(bool videoEnabled) {
    isVideoEnabled = videoEnabled;
    state = OnVideoUpdate(videoEnabled);
  }

  @override
  void onAudioUpdate(bool audioEnabled) {
    isAudioEnabled = audioEnabled;
    state = OnAudioUpdate(audioEnabled);
  }

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {
    state = OnMeetingRoomJoinedWithoutCameraPermission();
  }

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {
    state = OnMeetingRoomJoinedWithoutMicPermission();
  }

  @override
  void onRemovedFromMeeting() {
    state = OnRemovedFromMeeting();
  }

  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {
    state = OnWaitListStatusUpdate(waitListStatus);
  }

  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}
}
