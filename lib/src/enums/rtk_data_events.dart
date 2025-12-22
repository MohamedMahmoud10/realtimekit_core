enum RtkDataEventsName {
  onMetaUpdate("onMetaUpdate"),
  onSelfPermissionsUpdate("onSelfPermissionsUpdate"),
  onPluginsUpdates("onPluginsUpdates"),
  onScreenShareUpdate("onScreenShareUpdate"),
  onLivestreamUpdate("onLivestreamUpdate"),
  unknown("unknown");

  final String name;
  const RtkDataEventsName(this.name);

  static RtkDataEventsName fromString(String name) {
    switch (name) {
      case "onMetaUpdate":
        return RtkDataEventsName.onMetaUpdate;
      case "onSelfPermissionsUpdate":
        return RtkDataEventsName.onSelfPermissionsUpdate;
      case 'onPluginsUpdates':
        return RtkDataEventsName.onPluginsUpdates;
      case 'onScreenShareUpdate':
        return RtkDataEventsName.onScreenShareUpdate;
      case 'onLivestreamUpdate':
        return RtkDataEventsName.onLivestreamUpdate;
      default:
        return RtkDataEventsName.unknown;
    }
  }
}
