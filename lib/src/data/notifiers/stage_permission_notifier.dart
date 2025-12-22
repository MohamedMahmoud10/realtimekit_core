import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StagePermissionNotifier extends Notifier<MediaPermission>
    implements RtkDataEventListener {
  MediaPermission _getStagePermission() {
    final audioPermission = rtkMeeting.permissions.media.audio;
    final videoPermission = rtkMeeting.permissions.media.video.permission;
    MediaPermission stagePermission;
    if (audioPermission == MediaPermission.notAllowed ||
        videoPermission == MediaPermission.notAllowed) {
      stagePermission = MediaPermission.notAllowed;
    } else if (audioPermission == MediaPermission.canRequest ||
        videoPermission == MediaPermission.canRequest) {
      stagePermission = MediaPermission.canRequest;
    } else {
      stagePermission = MediaPermission.allowed;
    }

    return stagePermission;
  }

  @override
  MediaPermission build() {
    return _getStagePermission();
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
  void onScreenShareUpdate(List<RtkMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {
    state = _getStagePermission();
  }
}
