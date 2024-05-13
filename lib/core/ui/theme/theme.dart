import 'package:flutter/material.dart';

import '../../../core/ui/theme/color_scheme.dart';
import '../../../core/ui/theme/text_theme.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const String fontFamily = 'Inter';
    final AppColorScheme colorScheme = AppColorScheme.light();
    final AppTextTheme textTheme = AppTextTheme(
      fontFamily: fontFamily,
      color: colorScheme.onSurfaceDim,
    );
    final AppBarTheme appBarTheme = AppBarTheme(
      backgroundColor: colorScheme.primary,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: textTheme.titleMedium.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    );

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: fontFamily,
      extensions: <ThemeExtension<dynamic>>[
        colorScheme,
        textTheme,
      ],
      appBarTheme: appBarTheme,
      scaffoldBackgroundColor: colorScheme.onPrimary,
    );
  }
}
