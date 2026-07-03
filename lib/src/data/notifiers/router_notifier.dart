import 'package:flutter/foundation.dart';
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
    debugPrint('[RtkRouter] onMeetingInitStarted');
    state = OnRouterMeetingInitStarted();
  }

  @override
  void onMeetingInitCompleted() {
    debugPrint('[RtkRouter] onMeetingInitCompleted');
    state = OnRouterMeetingInitCompleted();
  }

  @override
  void onMeetingInitFailed(MeetingError error) {
    debugPrint('[RtkRouter] onMeetingInitFailed: $error');
    state = OnRouterMeetingInitFailed(error);
  }

  @override
  void onMeetingRoomJoinStarted() {
    debugPrint('[RtkRouter] onMeetingRoomJoinStarted');
    state = OnRouterMeetingRoomJoinStarted();
  }

  @override
  void onMeetingRoomJoinCompleted() {
    debugPrint('[RtkRouter] onMeetingRoomJoinCompleted');
    state = OnRouterMeetingRoomJoinCompleted();
  }

  @override
  void onMeetingRoomJoinFailed(MeetingError error) {
    debugPrint('[RtkRouter] onMeetingRoomJoinFailed: $error');
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
    debugPrint('[RtkRouter] onWaitListStatusUpdate: $waitListStatus');
    state = OnRouterSelfWaitingRoomStatusUpdate(waitListStatus);
  }

  @override
  void onRemovedFromMeeting() {
    debugPrint('[RtkRouter] onRemovedFromMeeting');
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
    debugPrint('[RtkRouter] onMeetingEnded');
    state = OnRouterMeetingEnded();
  }

  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onSocketConnectionUpdate(SocketConnectionState socketState) {
    debugPrint(
        '[RtkRouter] onSocketConnectionUpdate: ${socketState.socketState} '
        'reconnected=${socketState.reconnected} attempt=${socketState.reconnectionAttempt}');
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
