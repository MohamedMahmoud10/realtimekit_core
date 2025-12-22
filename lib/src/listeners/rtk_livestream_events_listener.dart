import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkLivestreamEventListener extends RtkListener {
  void onLiveStreamStarting() {}
  void onLiveStreamStarted() {}
  void onLiveStreamStateUpdate(RtkLivestreamData data) {}
  void onViewerCountUpdated(int count) {}
  void onLiveStreamEnding() {}
  void onLiveStreamEnded() {}
  void onLiveStreamErrored() {}
  void onStageCountUpdated(int count) {}
}

class RtkLivestreamController
    implements RtkLivestreamEventListener, RtkDataEventListener {
  RtkLivestreamController._();

  RtkLivestreamData _data = RtkLivestreamData(
    playbackUrl: "",
    state: LivestreamState.none,
    viewerCount: 0,
  );

  int _stageCount = 0;

  RtkLivestreamData get data => _data;

  int get stageCount => _stageCount;

  static final RtkLivestreamController instance = RtkLivestreamController._();

  @override
  void onLiveStreamStateUpdate(RtkLivestreamData data) {
    _data = data;
  }

  @override
  void onViewerCountUpdated(int count) {
    _data.viewerCount = count;
  }

  @override
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {
    _data = livestreamData;
  }

  @override
  void onLiveStreamEnded() {
    _data.state = LivestreamState.ended;
  }

  @override
  void onLiveStreamErrored() {
    _data.state = LivestreamState.errored;
  }

  @override
  void onLiveStreamEnding() {
    _data.state = LivestreamState.ending;
  }

  @override
  void onLiveStreamStarting() {
    _data.state = LivestreamState.starting;
  }

  @override
  void onLiveStreamStarted() {
    _data.state = LivestreamState.started;
  }

  @override
  void onStageCountUpdated(int count) {
    _stageCount = count;
  }

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    RtkMeetingType meetingType,
    RtkDesignTokens designToken,
  ) {}

  @override
  void onPluginUpdate(List<RtkPlugin> plugin) {}

  @override
  void onScreenShareUpdate(List<RtkMeetingParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}

  void dispose() {
    _data = RtkLivestreamData(
      playbackUrl: "",
      state: LivestreamState.none,
      viewerCount: 0,
    );
    _stageCount = 0;
  }
}
