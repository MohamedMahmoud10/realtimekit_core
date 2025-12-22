import 'package:flutter/material.dart';

enum ButtonState {
  normal,
  loading,
  complete,
  disabled,
}

class RtkButtonController extends ValueNotifier<ButtonState> {
  RtkButtonController() : super(ButtonState.normal);

  void changeState(ButtonState state) => value = state;
}
