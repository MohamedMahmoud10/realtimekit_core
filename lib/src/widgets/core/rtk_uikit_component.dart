import 'package:flutter/material.dart';

abstract class UiKitElement {
  double get borderRadius;
  double get borderWidth;
  Color get fillColor;
  Color get textColor;
}

mixin UsesStatusColor {
  Color get warningColor;
  Color get errorColor;
  Color get successColor;
}
