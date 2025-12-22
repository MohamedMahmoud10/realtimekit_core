enum RtkPluginEventsMethodNames {
  onPluginActivated("onPluginActivated"),
  onPluginDeactivated("onPluginDeactivated"),
  onPluginMessage("onPluginMessage"),
  onPluginFileRequest("onPluginFileRequest");

  final String name;

  const RtkPluginEventsMethodNames(this.name);

  static RtkPluginEventsMethodNames fromName(String name) {
    switch (name) {
      case "onPluginActivated":
        return RtkPluginEventsMethodNames.onPluginActivated;
      case "onPluginMessage":
        return RtkPluginEventsMethodNames.onPluginMessage;
      case "onPluginFileRequest":
        return RtkPluginEventsMethodNames.onPluginFileRequest;
      case "onPluginDeactivated":
        return RtkPluginEventsMethodNames.onPluginDeactivated;
      default:
        return RtkPluginEventsMethodNames.onPluginDeactivated;
    }
  }
}
