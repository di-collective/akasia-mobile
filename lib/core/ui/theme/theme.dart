import '../../../core/ui/theme/color_scheme.dart';
import '../../../core/ui/theme/text_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const String fontFamily = 'Inter';
    final AppColorScheme colorScheme = AppColorScheme.light();
    final AppTextTheme textTheme = AppTextTheme(
      fontFamily: fontFamily,
      color: colorScheme.onSurfaceDim,
    );
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: fontFamily,
      extensions: <ThemeExtension<dynamic>>[
        colorScheme,
        textTheme,
      ],
      scaffoldBackgroundColor: colorScheme.onPrimary,
    );
  }
}
