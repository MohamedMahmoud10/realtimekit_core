import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/color/status_color.dart';
import 'package:realtimekit_ui/src/tokens/font/font.dart';
import 'package:flutter/material.dart';

import '../di/di.dart';

class AppTheme {
  final RtkColorToken colorToken;
  AppTheme(this.colorToken);

  ThemeData get theme => ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primaryContainer: backgroundColorSwatch.shade800,
          secondaryContainer: backgroundColorSwatch.shade700,
          tertiaryContainer: backgroundColorSwatch.shade600,
          outline: colorToken.backgroundColor.shade700,
          primary: colorToken.brandColor.shade500,
          onPrimary: colorToken.textColor.shade1000,
          secondary: colorToken.backgroundColor.shade1000,
          onSecondary: colorToken.textColor.shade1000,
          error: StatusColor.error,
          tertiary: StatusColor.success,
          onError: colorToken.textColor.shade1000,
          surface: colorToken.backgroundColor.shade900,
          onSurface: colorToken.textColor.shade1000,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: textColorSwatch.shade1000,
            fontSize: fontSize.s300,
            fontWeight: FontWeight.w600,
            fontFamily: Font.name,
          ),
          displayMedium: TextStyle(
            color: textColorSwatch.shade1000,
            fontFamily: Font.name,
            fontSize: fontSize.s100,
            fontWeight: FontWeight.w500,
          ),
          displaySmall: TextStyle(
            color: textColorSwatch.shade1000,
            fontSize: fontSize.s75,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: textColorSwatch.shade1000,
            fontSize: fontSize.s125,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: fontSize.s88,
            color: textColorSwatch.shade700,
          ),
          bodyMedium: TextStyle(
            color: textColorSwatch.shade1000,
            fontSize: fontSize.s100,
          ),
          headlineSmall: TextStyle(
            color: textColorSwatch.shade1000,
            fontSize: fontSize.s100,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            color: textColorSwatch.shade900,
            fontWeight: FontWeight.w300,
            fontSize: fontSize.s88,
          ),
        ),
      );
}
