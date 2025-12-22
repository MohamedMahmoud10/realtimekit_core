enum RtkRecordingEvents {
  onRecordingStateChanged("onRecordingStateChanged"),
  unknown("unknown");

  final String name;

  const RtkRecordingEvents(this.name);

  static RtkRecordingEvents fromString(String name) {
    switch (name) {
      case "onRecordingStateChanged":
        return RtkRecordingEvents.onRecordingStateChanged;
      default:
        return RtkRecordingEvents.unknown;
    }
  }
}
