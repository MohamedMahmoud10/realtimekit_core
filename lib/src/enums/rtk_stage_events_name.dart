enum RtkStageEventsName {
  onStageAccessRequestAccepted('onStageAccessRequestAccepted'),
  onStageAccessRequestRejected('onStageAccessRequestRejected'),
  onStageAccessRequestsUpdated('onStageAccessRequestsUpdated'),
  onNewStageAccessRequest('onNewStageAccessRequest'),
  onPeerStageStatusUpdated('onPeerStageStatusUpdated'),
  onRemovedFromStage('onRemovedFromStage'),
  onStageStatusUpdated('onStageStatusUpdated'),
  unknown('unknown');

  final String name;
  const RtkStageEventsName(this.name);

  static fromString(String name) {
    return RtkStageEventsName.values.firstWhere(
      (element) => element.name == name,
      orElse: () => RtkStageEventsName.unknown,
    );
  }
}
