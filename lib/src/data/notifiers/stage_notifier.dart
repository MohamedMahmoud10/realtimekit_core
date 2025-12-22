import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class StageStatusNotifier extends Notifier<StageStatus>
    implements RtkStageEventListener {
  @override
  StageStatus build() {
    return rtkMeeting.stage.status;
  }

  @override
  void onRemovedFromStage() {}

  @override
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {
    state = newStatus;
  }

  @override
  void onNewStageAccessRequest(RtkRemoteParticipant participant) {
    // TODO: implement onNewStageAccessRequest
  }

  @override
  void onPeerStageStatusUpdated(RtkRemoteParticipant participant,
      StageStatus oldStatus, StageStatus newStatus) {
    // TODO: implement onPeerStageStatusUpdated
  }

  @override
  void onStageAccessRequestAccepted() {
    // TODO: implement onStageAccessRequestAccepted
  }

  @override
  void onStageAccessRequestRejected() {
    // TODO: implement onStageAccessRequestRejected
  }

  @override
  void onStageAccessRequestsUpdated(List<RtkRemoteParticipant> accessRequests) {
    // TODO: implement onStageAccessRequestsUpdated
  }
}

class StageRequestsNotifier extends Notifier<List<RtkRemoteParticipant>>
    implements RtkStageEventListener {
  @override
  List<RtkRemoteParticipant> build() {
    return rtkMeeting.stage.accessRequests;
  }

  @override
  void onRemovedFromStage() {}

  @override
  void onNewStageAccessRequest(RtkRemoteParticipant participant) {
    state = [...state, participant];
  }

  @override
  void onPeerStageStatusUpdated(RtkRemoteParticipant participant,
      StageStatus oldStatus, StageStatus newStatus) {
    state = state
        .map((p) =>
            p == participant ? participant.copyWith(stageStatus: newStatus) : p)
        .toList();
  }

  @override
  void onStageAccessRequestAccepted() {
    // TODO: implement onStageAccessRequestAccepted
  }

  @override
  void onStageAccessRequestRejected() {
    // TODO: implement onStageAccessRequestRejected
  }

  @override
  void onStageAccessRequestsUpdated(List<RtkRemoteParticipant> accessRequests) {
    // TODO: implement onStageAccessRequestsUpdated
  }

  @override
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {
    // TODO: implement onStageStatusUpdated
  }
}

class UnreadStageRequestsCountNotifier extends Notifier<int>
    implements RtkStageEventListener {
  void markAllAsRead() {
    state = 0;
  }

  @override
  int build() {
    return rtkMeeting.stage.accessRequests.length;
  }

  @override
  void onNewStageAccessRequest(RtkRemoteParticipant participant) {
    // TODO: implement onNewStageAccessRequest
  }

  @override
  void onPeerStageStatusUpdated(RtkRemoteParticipant participant,
      StageStatus oldStatus, StageStatus newStatus) {
    // TODO: implement onPeerStageStatusUpdated
  }

  @override
  void onStageAccessRequestAccepted() {
    // TODO: implement onStageAccessRequestAccepted
  }

  @override
  void onStageAccessRequestRejected() {
    // TODO: implement onStageAccessRequestRejected
  }

  @override
  void onStageAccessRequestsUpdated(List<RtkRemoteParticipant> accessRequests) {
    state = accessRequests.length;
  }

  @override
  void onRemovedFromStage() {
    // TODO: implement onRemovedFromStage
  }

  @override
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {
    // TODO: implement onStageStatusUpdated
  }
}
