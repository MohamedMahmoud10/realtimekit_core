import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/color/status_color.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';

class RtkIconButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  // the purpose of putting isDisabled here is not to pass `null` to onPressed
  // but to show alert icon on the button
  final bool isDisabled;
  const RtkIconButton({
    required this.icon,
    this.height,
    this.width,
    this.iconSize,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
    this.isDisabled = false,
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final Color? backgroundColor;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? context.adjust(48),
      width: width ?? context.adjust(48),
      decoration: BoxDecoration(
        color: backgroundColor ?? backgroundColorSwatch.shade900,
        borderRadius: BorderRadius.circular(
          borderToken.getRadius(BorderSize.one),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isDisabled)
            const Positioned(
              right: 4,
              top: 4,
              child: Icon(
                DyteIcons.warning,
                color: StatusColor.warning,
                size: 14,
              ),
            ),
          IconButton(
            iconSize: iconSize ?? 24,
            splashRadius: 1,
            onPressed: isDisabled ? null : onPressed,
            disabledColor: backgroundColorSwatch.shade700,
            icon: icon,
            padding: padding,
          ),
        ],
      ),
    );
  }
}
