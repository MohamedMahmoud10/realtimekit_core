import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkStageEventListener extends RtkListener {
  void onStageAccessRequestAccepted() {}
  void onStageAccessRequestRejected() {}
  void onStageAccessRequestsUpdated(
      List<RtkRemoteParticipant> accessRequests) {}
  void onNewStageAccessRequest(RtkRemoteParticipant participant) {}
  void onPeerStageStatusUpdated(RtkRemoteParticipant participant,
      StageStatus oldStatus, StageStatus newStatus) {}
  void onRemovedFromStage() {}
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {}
}

class RtkStageController extends RtkStageEventListener {
  RtkStageController._();

  static final RtkStageController instance = RtkStageController._();

  List<RtkRemoteParticipant> _accessRequests = [];

  List<RtkRemoteParticipant> get accessRequests => _accessRequests;

  StageStatus _stageStatus = StageStatus.offStage;

  StageStatus get stageStatus => _stageStatus;

  @override
  void onStageAccessRequestsUpdated(List<RtkRemoteParticipant> accessRequests) {
    _accessRequests = accessRequests;
  }

  @override
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {
    _stageStatus = newStatus;
  }

  void dispose() {
    _accessRequests.clear();
    _stageStatus = StageStatus.offStage;
  }
}
