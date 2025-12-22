import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/app_size.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/core/button/rtk_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';

part 'rtk_buttons.dart';

/// [IconPosition] is used to position the icon in the button.
/// [left] is used to position the icon to the left of the button.
/// [right] is used to position the icon to the right of the button.
enum IconPosition { left, right }

class RtkButtons {
  /// Returns a [RtkButton] with a solid background color.
  /// [label] is the text to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [RtkDesignTokens] but it is optional.

  RtkButtons._();

  static RtkButton solid({
    required String label,
    required VoidCallback? onPressed,
    RtkDesignTokens? designToken,
    RtkButtonController? controller,
    Color? backgroundColor,
    double? width,
    double? height,
  }) =>
      _RtkSolidButton(
        label: label,
        onPressed: onPressed,
        individualDesignToken: designToken,
        height: height,
        width: width,
        backgroundColor: backgroundColor,
        controller: controller ?? RtkButtonController(),
      );

  //TODO: add an expanded button.

  /// Returns a [RtkButton] with a solid background color.
  /// [label] is the text to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [RtkDesignTokens] but it is optional.
  /// [icon] is the icon to be displayed on the button.
  /// [iconPostion] is the position of the icon on the button.
  /// [width] is the width of the button.
  /// [height] is the height of the button.
  static RtkButton iconWithLabel({
    required String label,
    required VoidCallback? onPressed,
    required Icon icon,
    IconPosition? iconPostion,
    RtkDesignTokens? designToken,
    RtkButtonController? controller,
    double? width,
    double? height,
  }) =>
      _RtkSolidIconButtonWithLabel(
        height: height,
        iconPosition: iconPostion ?? IconPosition.left,
        individualDesignToken: designToken,
        onPressed: onPressed,
        label: label,
        icon: icon,
        controller: controller ?? RtkButtonController(),
      );

  /// Returns a [RtkButton] with only an icon.
  /// [icon] is the icon to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [RtkDesignTokens] but it is optional.

  static RtkButton icon(
    Icon icon, {
    required VoidCallback? onPressed,
    RtkDesignTokens? designToken,
    double? iconSize,
    RtkButtonController? controller,
    bool isDisabled = false,
  }) =>
      _RtkIconButton(
        iconSize: iconSize,
        individualDesignToken: designToken,
        onPressed: onPressed,
        icon: icon,
        controller: controller ?? RtkButtonController(),
        isDisabled: isDisabled,
        label: '',
      );
}
