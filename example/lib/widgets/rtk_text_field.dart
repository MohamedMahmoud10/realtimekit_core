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

  const RtkTextField({
    super.key,
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
    this.width = 360,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        validator: validator,
        style: theme.textTheme.bodyMedium,
        enabled: enabled,
        keyboardType: inputType,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          border:
              border ??
              const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
          hintStyle: hintStyle ?? theme.textTheme.bodyMedium,
        ),
        controller: controller,
      ),
    );
  }
}
