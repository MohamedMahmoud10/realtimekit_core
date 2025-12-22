import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';

class RtkTextField extends StatelessWidget {
  final String? hintText;
  final String? prefixText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final double? width;
  final double? height;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final Color? fillColor;
  final int? maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  const RtkTextField({
    Key? key,
    required this.controller,
    this.prefixText,
    this.hintText,
    this.enabled = true,
    this.textInputAction,
    this.border,
    this.validator,
    this.fillColor,
    this.maxLines = 1,
    this.hintStyle,
    this.inputType,
    this.width = 40,
    this.height = 80,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        validator: validator,
        style: theme.textTheme.bodyMedium,
        enabled: enabled,
        cursorColor: brandColorSwatch.shade500,
        keyboardType: inputType,
        onChanged: onChanged,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          fillColor: fillColor ?? backgroundColorSwatch.shade900,
          filled: true,
          hintText: hintText,
          border: border ??
              OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                      Radius.circular(borderToken.getRadius(BorderSize.one)))),
          hintStyle: hintStyle ?? theme.textTheme.bodyMedium,
        ),
        controller: controller,
      ),
    );
  }
}
