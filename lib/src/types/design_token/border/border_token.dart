import 'border_properties.dart';

class BorderToken {
  BorderToken({
    double thinFactor = 1,
    double fatFactor = 2,
    double roundFactor = 4,
    double extraRoundFactor = 8,
    double circularFactor = 8,
    required this.borderRadius,
    required this.borderWidth,
  })  : _fatFactor = fatFactor,
        _thinFactor = thinFactor,
        _circularFactor = circularFactor,
        _extraRoundFactor = extraRoundFactor,
        _roundFactor = roundFactor;
  late final double _thinFactor;
  late final double _fatFactor;

  late final double _roundFactor;
  late final double _extraRoundFactor;
  late final double _circularFactor;

  final RtkBorderRadius borderRadius;
  final RtkBorderWidth borderWidth;

  /// Caculates border width for the passed [width] and [size].
  double getWidth(BorderSize size) => _calculateWidth(borderWidth, size);

  /// Calculates border radius for passed [radius] and [size].
  double getRadius(BorderSize size) => _calculateRadius(size, borderRadius);

  double _calculateRadius(BorderSize size, RtkBorderRadius radius) {
    switch (radius) {
      case RtkBorderRadius.sharp:
        return 0;
      case RtkBorderRadius.rounded:
        return _caculateRadiusForRounded(size);
      case RtkBorderRadius.extrarounded:
        return _caculateRadiusForExtraRounded(size);
      case RtkBorderRadius.circular:
        return _calculateRadiusForCircular(size);
    }
  }

  double _caculateRadiusForRounded(BorderSize size) {
    switch (size) {
      case BorderSize.zero:
        return 0;
      case BorderSize.one:
        return _roundFactor * 1;
      case BorderSize.two:
        return _roundFactor * 2;
      case BorderSize.three:
        return _roundFactor * 4;
      case BorderSize.max:
        return 9999;
    }
  }

  double _caculateRadiusForExtraRounded(BorderSize size) {
    switch (size) {
      case BorderSize.zero:
        return 0;
      case BorderSize.one:
        return _extraRoundFactor * 1;
      case BorderSize.two:
        return _extraRoundFactor * 2;
      case BorderSize.three:
        return _extraRoundFactor * 4;
      case BorderSize.max:
        return 9999;
    }
  }

  double _calculateRadiusForCircular(BorderSize size) {
    switch (size) {
      case BorderSize.zero:
        return 999;
      case BorderSize.one:
        return 1;
      case BorderSize.two:
        return _circularFactor * 2;
      case BorderSize.three:
        return _extraRoundFactor * 3;
      case BorderSize.max:
        return 9999;
    }
  }

  double _calculateWidth(RtkBorderWidth width, BorderSize size) {
    switch (width) {
      case RtkBorderWidth.none:
        return 0;
      case RtkBorderWidth.thin:
        return _calculateThinWidth(size);
      case RtkBorderWidth.fat:
        return _calculateFatWidth(size);
    }
  }

  double _calculateThinWidth(BorderSize size) {
    switch (size) {
      case BorderSize.zero:
        return 0;
      case BorderSize.one:
        return _thinFactor * 1;
      case BorderSize.two:
        return _thinFactor * 2;
      case BorderSize.three:
        return _thinFactor * 4;
      case BorderSize.max:
        return 9999;
    }
  }

  double _calculateFatWidth(BorderSize size) {
    switch (size) {
      case BorderSize.zero:
        return 0;
      case BorderSize.one:
        return _fatFactor * 1;
      case BorderSize.two:
        return _fatFactor * 2;
      case BorderSize.three:
        return _fatFactor * 4;
      case BorderSize.max:
        return 9999;
    }
  }
}
