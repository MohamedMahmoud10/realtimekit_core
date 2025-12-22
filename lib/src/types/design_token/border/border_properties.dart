enum RtkBorderWidth {
  none("none"),
  thin("thin"),
  fat("fat");

  final String value;
  const RtkBorderWidth(this.value);

  static RtkBorderWidth fromString(String value) {
    switch (value) {
      case "none":
        return RtkBorderWidth.none;
      case "thin":
        return RtkBorderWidth.thin;
      case "fat":
        return RtkBorderWidth.fat;
      default:
        return RtkBorderWidth.none;
    }
  }
}

enum BorderSize { zero, one, two, three, max }

enum RtkBorderRadius {
  sharp("sharp"),
  rounded("rounded"),
  extrarounded("extrarounded"),
  circular("circular");

  final String value;
  const RtkBorderRadius(this.value);

  static RtkBorderRadius fromString(String value) {
    switch (value) {
      case "sharp":
        return RtkBorderRadius.sharp;
      case "rounded":
        return RtkBorderRadius.rounded;
      case "extra-rounded":
        return RtkBorderRadius.extrarounded;
      case "circular":
        return RtkBorderRadius.circular;
      default:
        return RtkBorderRadius.rounded;
    }
  }
}
