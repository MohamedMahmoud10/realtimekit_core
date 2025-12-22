import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

class RtkColorToken {
  final Color danger;
  final Color success;
  final Color warning;

  /// [_backgroundColor] generates all the colors from the [baseBackground].
  final LinearColorSwatch _backgroundColor;

  /// [_brandColor] generates all the colors from the [basePrimary].
  final RangedColorSwatch _brandColor;

  /// [_textColor] generates all the colors from the [_textColor] in the params.
  final LinearColorSwatch _textColor;

  LinearColorSwatch get backgroundColor => _backgroundColor;

  RangedColorSwatch get brandColor => _brandColor;

  LinearColorSwatch get textColor => _textColor;

  static const double _brandColorFactor = 0.04;
  static const double _backgroundColorFactor = 0.08;
  static const double _textColorFactor = 0.12;
  static const Color _rtkDefaultError = Color(0xFFFF2D2D);
  static const Color _rtkDefaulSuccess = Color(0xFF83D017);
  static const Color _rtkDefaultWarning = Color(0xFFFFCD07);

  RtkColorToken({
    RtkColorSwatch? brandColorSwatch,
    RtkColorSwatch? backgroundColorSwatch,
    Color? brandColor,
    Color? backgroundColor,
    Color? textOnBrand,
    Color? textOnBackground,
    this.danger = _rtkDefaultError,
    this.success = _rtkDefaulSuccess,
    this.warning = _rtkDefaultWarning,
  })  : assert(brandColorSwatch == null || brandColor == null,
            'You cannot provide both brandColorSwatch and brand color'),
        assert(
          backgroundColorSwatch == null || backgroundColor == null,
          'You cannot provide both backgroundColorSwatch and background color',
        ),
        assert(
          brandColorSwatch != null || brandColor != null,
          'You must provide either brandColorSwatch or brand color',
        ),
        assert(
          backgroundColorSwatch != null || backgroundColor != null,
          'You must provide either backgroundColorSwatch or background color',
        ),
        assert(
          backgroundColorSwatch != null
              ? _checkBackgroundSwatch(backgroundColorSwatch)
              : true,
          'backgroundColorSwatch should have 5 entries with keys 600, 700, 800, 900, 1000',
        ),
        assert(
          brandColorSwatch != null ? _checkBrandSwatch(brandColorSwatch) : true,
          'brandColorSwatch should have 5 entries with keys 300, 400, 500, 600, 700',
        ),
        _backgroundColor = LinearColorSwatch(backgroundColor,
            factor: _backgroundColorFactor, colorSwatch: backgroundColorSwatch),
        _brandColor = RangedColorSwatch(brandColor,
            factor: _brandColorFactor, colorSwatch: brandColorSwatch),
        _textColor = LinearColorSwatch(textOnBrand,
            factor: _textColorFactor,
            swatchConfig: SwatchConfig.darker,
            colorSwatch: null);

  static bool _checkBrandSwatch(RtkColorSwatch brandColorSwatch) {
    bool isSwatchValid = true;
    brandColorSwatch.swatch.forEach((key, value) {
      isSwatchValid = isSwatchValid && (key >= 300 && key <= 700);
    });
    isSwatchValid =
        isSwatchValid && brandColorSwatch.swatch.entries.length == 5;
    return isSwatchValid;
  }

  static bool _checkBackgroundSwatch(RtkColorSwatch backgroundColorSwatch) {
    bool isSwatchValid = true;
    backgroundColorSwatch.swatch.forEach((key, value) {
      isSwatchValid = isSwatchValid && (key >= 600 && key <= 1000);
    });
    isSwatchValid =
        isSwatchValid && backgroundColorSwatch.swatch.entries.length == 5;
    return isSwatchValid;
  }
}
