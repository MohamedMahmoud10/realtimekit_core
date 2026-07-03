import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginNotifer extends Notifier<List<RtkPlugin>>
    implements RtkDataEventListener {
  @override
  void onPluginUpdate(List<RtkPlugin> plugins) {
    final activePlugins = plugins.where((plugin) => plugin.isActive).toList();
    state = activePlugins;
  }

  @override
  List<RtkPlugin> build() {
    return [];
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
  void onScreenShareUpdate(List<RtkMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}

  @override
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {}
}
