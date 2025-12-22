import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/router_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouterNotifier extends Notifier<RouterStates>
    implements RtkMeetingRoomEventListener, RtkSelfEventListener {
  SocketConnectionState? socketState;
  @override
  RouterStates build() {
    return RouterInitial();
  }

  @override
  void onMeetingInitStarted() {
    state = OnRouterMeetingInitStarted();
  }

  @override
  void onMeetingInitCompleted() {
    state = OnRouterMeetingInitCompleted();
  }

  @override
  void onMeetingInitFailed(MeetingError error) {
    state = OnRouterMeetingInitFailed(error);
  }

  @override
  void onMeetingRoomJoinStarted() {
    state = OnRouterMeetingRoomJoinStarted();
  }

  @override
  void onMeetingRoomJoinCompleted() {
    state = OnRouterMeetingRoomJoinCompleted();
  }

  @override
  void onMeetingRoomJoinFailed(MeetingError error) {
    state = OnRouterMeetingRoomJoinFailed(error);
  }

  @override
  void onMeetingRoomLeaveStarted() {
    state = OnRouterMeetingRoomLeaveStarted();
  }

  @override
  void onMeetingRoomLeaveCompleted() {
    state = OnRouterMeetingRoomLeaveCompleted();
  }

  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {
    state = OnRouterSelfWaitingRoomStatusUpdate(waitListStatus);
  }

  @override
  void onRemovedFromMeeting() {
    state = OnRouterRemovedFromMeeting();
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
  void onUpdate(RtkSelfParticipant participant) {}

  @override
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onActiveTabUpdate(ActiveTab? activeTab) {}

  @override
  void onMeetingEnded() {
    state = OnRouterMeetingEnded();
  }

  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onSocketConnectionUpdate(SocketConnectionState socketState) {
    this.socketState = socketState;
    switch (socketState.socketState) {
      case SocketState.connected:
        if (socketState.reconnected) {
          state = OnRouterMeetingRoomReconnected();
        }
        break;
      case SocketState.reconnecting:
        if (socketState.reconnectionAttempt == 0) {
          state = OnRouterMeetingRoomReconnecting();
        }
        break;
      case SocketState.failed:
        if (socketState.isReconnectionFailure) {
          state = OnRouterMeetingRoomReconnectionFailed();
        }
        break;
      default:
        break;
    }
  }

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}
}
