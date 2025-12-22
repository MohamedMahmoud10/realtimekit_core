import 'package:flutter/material.dart';

extension ColorsUtils on Color {
  /// Takes in [by] and returns a new color with brightness increased with [by].
  /// Value of [by] ranges from 0 to 1
  Color lighter({double by = .1}) {
    assert(by >= 0 && by <= 1, 'by ranges from 0 to 1');

    final hslValue = HSLColor.fromColor(this);
    final hslLighter =
        hslValue.withLightness((hslValue.lightness + by).clamp(0, 1));
    return hslLighter.toColor();
  }

  /// Takes in [by] and returns a new color with brightness decreased with [by].
  /// Value of [by] ranges from 0 to 1
  Color darker({double by = .1}) {
    assert(by >= 0 && by <= 1, 'by ranges from 0 to 1');

    final hslValue = HSLColor.fromColor(this);
    final hslDarker =
        hslValue.withLightness((hslValue.lightness - by).clamp(0, 1));
    return hslDarker.toColor();
  }
}

/// returns a [Color] object by taking a String hex in the format of "#FFFFFF"
Color getColorFromStringHex(String hex) {
  assert(hex.startsWith("#"), 'Hex color needs to start with a # symbol');
  return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
}
