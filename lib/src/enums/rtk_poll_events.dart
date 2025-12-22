enum RtkPollEventsName {
  onNewPoll("onNewPoll"),
  onPollUpdates("onPollUpdates"),
  onPollUpdate("onPollUpdate"),
  unknown("unknown");

  final String name;
  const RtkPollEventsName(this.name);

  static RtkPollEventsName fromString(String name) {
    switch (name) {
      case "onNewPoll":
        return RtkPollEventsName.onNewPoll;
      case "onPollUpdates":
        return RtkPollEventsName.onPollUpdates;
      default:
        return RtkPollEventsName.unknown;
    }
  }
}
