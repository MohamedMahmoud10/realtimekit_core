enum StageStatus {
  offStage("offStage"),
  requestedToJoinStage("requestedToJoinStage"),
  acceptedToJoinStage("acceptedToJoinStage"),
  onStage("onStage");

  final String name;
  const StageStatus(this.name);

  static StageStatus fromName(String name) {
    switch (name) {
      case "OFF_STAGE":
        return StageStatus.offStage;
      case "REQUESTED_TO_JOIN_STAGE":
        return StageStatus.requestedToJoinStage;
      case "ACCEPTED_TO_JOIN_STAGE":
        return StageStatus.acceptedToJoinStage;
      case "ON_STAGE":
        return StageStatus.onStage;
      default:
        return StageStatus.offStage;
    }
  }
}
