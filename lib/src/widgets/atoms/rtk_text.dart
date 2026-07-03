import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';

/// Wrapper over text widget, it uses the defualt UI kit styles.
class RtkText extends StatelessWidget {
  const RtkText(
    this.data, {
    this.rtkTextStyle,
    super.key,
    this.textAlign,
    this.overflow,

    /// [disableOverflow] by default false,
    /// if set to true let's `Text` take any number of lines.
    this.disableOverflow = false,
  });

  final String data;
  final TextAlign? textAlign;
  final TextStyle? rtkTextStyle;
  final bool disableOverflow;
  final TextOverflow? overflow;

  static final _theme = AppTheme(globalDesignToken.colorToken).theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: rtkTextStyle ?? _theme.textTheme.bodyMedium,
      textAlign: textAlign,
      overflow: disableOverflow ? null : overflow ?? TextOverflow.ellipsis,
    );
  }
}
