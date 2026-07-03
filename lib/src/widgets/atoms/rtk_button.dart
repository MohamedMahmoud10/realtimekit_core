import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';

import 'package:realtimekit_core/realtimekit_core.dart';

class RtkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  const RtkButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return MaterialButton(
      onPressed: onPressed,
      color: backgroundColor ?? theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderToken.getRadius(BorderSize.one),
        ),
      ),
      height: height,
      child: child,
    );
  }
}
