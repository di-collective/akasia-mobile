import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/ui/theme/color_scheme.dart';
import '../../../core/ui/theme/text_theme.dart';

class AppTheme {
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
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceBright,
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: colorScheme.surfaceBright,
          ),
        ),
        labelStyle: textTheme.labelLarge.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        selectedColor: colorScheme.primaryTonal,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineBright,
        space: 0,
        thickness: 0.5,
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: colorScheme.primary,
      ),
      datePickerTheme: DatePickerThemeData(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  static SystemUiOverlayStyle get overlayStyleLight {
    return const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    );
  }
}
