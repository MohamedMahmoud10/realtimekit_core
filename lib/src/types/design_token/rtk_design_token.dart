import 'dart:convert';
import 'dart:ui';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

class RtkDesignTokens {
  RtkColorToken _colorToken;
  BorderToken _borderToken;

  static const Color _rtkBackground = Color(0xFF080808);
  static const Color _rtkPrimary = Color(0xFF2160FD);
  static const Color _text = Color(0xFFFFFFFF);

  RtkColorToken get colorToken => _colorToken;
  BorderToken get borderToken => _borderToken;

  void resetValue(RtkDesignTokens designTokens) {
    _colorToken = designTokens.colorToken;
    _borderToken = designTokens.borderToken;
  }

  @override
  bool operator ==(covariant RtkDesignTokens other) {
    if (identical(this, other)) return true;
    return other._colorToken == _colorToken &&
        other._borderToken == _borderToken;
  }

  RtkDesignTokens({
    RtkColorToken? colorToken,
    RtkBorderRadius borderRadius = RtkBorderRadius.rounded,
    RtkBorderWidth borderWidth = RtkBorderWidth.none,
  })  : _borderToken = BorderToken(
          borderRadius: borderRadius,
          borderWidth: borderWidth,
        ),
        _colorToken = colorToken ??
            RtkColorToken(
              brandColor: _rtkPrimary,
              backgroundColor: _rtkBackground,
              textOnBackground: _text,
              textOnBrand: _text,
            );

  static int parseColorStringToInt(String value) =>
      int.parse(value.replaceFirst(RegExp(r'#'), 'FF'), radix: 16);

  static RtkDesignTokens fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> colorMap =
        jsonDecode(map["colors"]) as Map<String, dynamic>;
    final Map<int, Color> bgColorSwatch =
        (colorMap["background"] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        int.parse(key),
        Color(
          parseColorStringToInt(value),
        ),
      ),
    );

    final Map<int, Color> brandColorSwatch =
        (colorMap["brand"] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        int.parse(key),
        Color(
          parseColorStringToInt(value),
        ),
      ),
    );

    return RtkDesignTokens(
      
      colorToken: RtkColorToken(
        brandColorSwatch: RtkColorSwatch(500, brandColorSwatch),
        backgroundColorSwatch: RtkColorSwatch(1000, bgColorSwatch),
        textOnBackground: Color(parseColorStringToInt(colorMap["text"])),
        textOnBrand: Color(
          parseColorStringToInt(colorMap["text_on_brand"]),
        ),
        danger: Color(
          parseColorStringToInt(colorMap["danger"]),
        ),
        success: Color(
          parseColorStringToInt(colorMap["success"]),
        ),
        warning: Color(
          parseColorStringToInt(colorMap["warning"]),
        ),
      ),
      borderRadius: RtkBorderRadius.fromString(map['borderRadiusType']),
      borderWidth: RtkBorderWidth.fromString(map['borderWidth']),
    );
  }

  @override
  int get hashCode => _colorToken.hashCode ^ _borderToken.hashCode;
}
