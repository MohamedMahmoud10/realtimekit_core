import 'package:flutter/material.dart';
import '../color/color_util.dart';

class RtkColorSwatch extends ColorSwatch<int> {
  final int _primary;
  final Map<int, Color> _swatch;

  const RtkColorSwatch(this._primary, this._swatch) : super(_primary, _swatch);

  @override
  Color operator [](int index) => _swatch[index]!;

  Map<int, Color> get swatch => _swatch;

  Color get primary => _swatch[_primary]!;
}

enum SwatchConfig {
  lighter,
  darker,
}

class RangedColorSwatch {
  final Color? _base;
  final double _factor;

  final RtkColorSwatch? colorSwatch;

  /// [factor] decides the percentage by which the colors will be generated for the swatch.
  RangedColorSwatch(
    this._base, {
    double factor = 0.01,
    this.colorSwatch,
  })  : assert(factor >= 0 && factor <= 1, 'factor ranges from 0 to 1'),
        assert(!(_base == null && colorSwatch == null),
            'base color or colorSwatch is required'),
        _factor = factor;

  /// The lightest shade.
  Color get shade300 =>
      colorSwatch != null ? colorSwatch![300] : _base!.lighter(by: _factor * 2);

  /// The 2nd lightest shade.
  Color get shade400 =>
      colorSwatch != null ? colorSwatch![400] : _base!.lighter(by: _factor);

  /// The default shade.
  Color get shade500 => colorSwatch != null ? colorSwatch!.primary : _base!;

  /// The 2nd darkest shade.
  Color get shade600 =>
      colorSwatch != null ? colorSwatch![600] : _base!.darker(by: _factor);

  /// The darkest shade.
  Color get shade700 =>
      colorSwatch != null ? colorSwatch![700] : _base!.darker(by: _factor * 2);
}

class LinearColorSwatch {
  final Color? _base;
  final double _factor;
  final SwatchConfig _config;
  final RtkColorSwatch? colorSwatch;

  /// [factor] decides the percentage by which the colors will be generated for the swatch.
  LinearColorSwatch(
    this._base, {
    double factor = 0.01,
    SwatchConfig swatchConfig = SwatchConfig.lighter,
    this.colorSwatch,
  })  : assert(factor >= 0 && factor <= 1),
        assert(!(_base == null && colorSwatch == null),
            'base color or colorSwatch is required'),
        _config = swatchConfig,
        _factor = factor;

  /// The default shade.
  Color get shade1000 => colorSwatch != null ? colorSwatch!.primary : _base!;

  /// The 1st lighter/darker shade.
  Color get shade900 => colorSwatch != null
      ? colorSwatch![900]
      : _config == SwatchConfig.lighter
          ? _base!.lighter(by: _factor)
          : _base!.darker(by: _factor);

  /// The 2nd lighter/darker shade.
  Color get shade800 => colorSwatch != null
      ? colorSwatch![800]
      : _config == SwatchConfig.lighter
          ? _base!.lighter(by: _factor * 2)
          : _base!.darker(by: _factor * 2);

  /// The 3rd lighter/darker shade.
  Color get shade700 => colorSwatch != null
      ? colorSwatch![700]
      : _config == SwatchConfig.lighter
          ? _base!.lighter(by: _factor * 3)
          : _base!.darker(by: _factor * 3);

  /// The 4th lighter/darker shade.
  Color get shade600 => colorSwatch != null
      ? colorSwatch![600]
      : _config == SwatchConfig.lighter
          ? _base!.lighter(by: _factor * 4)
          : _base!.darker(by: _factor * 4);
}
