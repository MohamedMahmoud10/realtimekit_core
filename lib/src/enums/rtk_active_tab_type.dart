enum RtkActiveTabType {
  plugin('plugin'),
  screenshare('screenshare');

  final String name;
  const RtkActiveTabType(this.name);

  static fromName(String name) {
    switch (name) {
      case 'plugin':
        return RtkActiveTabType.plugin;
      case 'screenshare':
        return RtkActiveTabType.screenshare;
      default:
        return RtkActiveTabType.plugin;
    }
  }
}
