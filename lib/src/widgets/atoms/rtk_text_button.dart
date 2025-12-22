import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/color/status_color.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

class RtkTextButton extends StatelessWidget {
  const RtkTextButton({
    super.key,
    required this.onPressed,
    this.label = "Button",
    this.variant = Variant.primary,
    this.labelStyle,
    this.height = 40,
    this.width = 80,
    this.borderColor,
  });
  final VoidCallback? onPressed;
  final Variant variant;
  final double width;
  final double height;
  final String label;
  final TextStyle? labelStyle;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return _buildBaseButton(variant, context);
  }

  Widget _buildBaseButton(Variant variant, BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderToken.getRadius(BorderSize.one),
          ),
          side: BorderSide(color: borderColor ?? Colors.transparent)),
      height: height,
      minWidth: width,
      // INFO: If color and Variant both are passed, then Color will override the Variant
      color: _mapVariantToColor(variant),
      onPressed: onPressed,
      child: RtkText(
        label,
        rtkTextStyle: labelStyle ??
            AppTheme(globalDesignToken.colorToken)
                .theme
                .textTheme
                .displayMedium,
      ),
    );
  }

  Color _mapVariantToColor(Variant variant) {
    switch (variant) {
      case Variant.danger:
        return StatusColor.error;
      case Variant.ghost:
        return Colors.transparent;
      case Variant.primary:
        return brandColorSwatch.shade500;
      case Variant.secondary:
        // TODO: check for original color.
        return backgroundColorSwatch.shade900;
      default:
        return brandColorSwatch.shade500;
    }
  }
}

enum Variant {
  danger,
  ghost,
  primary,
  secondary,
}
