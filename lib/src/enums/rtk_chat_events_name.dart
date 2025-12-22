enum RtkChatEventsName {
  onChatUpdates("onChatUpdates"),
  onNewChatMessage("onNewChatMessage"),
  unknown("unknown");

  final String name;
  const RtkChatEventsName(this.name);

  static RtkChatEventsName fromString(String name) {
    switch (name) {
      case "onChatUpdates":
        return RtkChatEventsName.onChatUpdates;
      case "onNewChatMessage":
        return RtkChatEventsName.onNewChatMessage;
      default:
        return RtkChatEventsName.unknown;
    }
  }
}
