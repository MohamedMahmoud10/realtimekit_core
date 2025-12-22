class FontSize {
  final double _baseSize;
  FontSize({double baseSize = 16}) : _baseSize = baseSize;

  double get s75 => 0.75 * _baseSize;

  double get s88 => 0.875 * _baseSize;

  double get s100 => 1.00 * _baseSize;

  double get s125 => 1.25 * _baseSize;

  double get s150 => 1.50 * _baseSize;

  double get s175 => 1.75 * _baseSize;

  double get s200 => 2.00 * _baseSize;

  double get s250 => 2.50 * _baseSize;

  double get s300 => 3.00 * _baseSize;
}
