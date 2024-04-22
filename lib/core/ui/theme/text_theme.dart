import 'package:flutter/material.dart';

class AppTextTheme extends ThemeExtension<AppTextTheme> {
  AppTextTheme._({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
  });

  factory AppTextTheme({
    required String fontFamily,
    required Color color,
    TextOverflow? overflow = TextOverflow.ellipsis,
  }) =>
      AppTextTheme._(
        displayLarge: const TextStyle(
            fontSize: 57.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            height: 57.0 / 64.0,
            letterSpacing: -0.25),
        displayMedium: const TextStyle(
          fontSize: 45.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 45.0 / 52.0,
        ),
        displaySmall: const TextStyle(
          fontSize: 36.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 36.0 / 44.0,
        ),
        headlineLarge: const TextStyle(
          fontSize: 32.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 32.0 / 40.0,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 28.0 / 36.0,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 24.0 / 32.0,
        ),
        titleLarge: const TextStyle(
          fontSize: 22.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 22.0 / 28.0,
        ),
        titleMedium: const TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 18.0 / 26.0,
          letterSpacing: 0.15,
        ),
        titleSmall: const TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 14.0 / 20.0,
          letterSpacing: 0.1,
        ),
        labelLarge: const TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 14.0 / 20.0,
          letterSpacing: 0.1,
        ),
        labelMedium: const TextStyle(
          fontSize: 12.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 12.0 / 16.0,
          letterSpacing: 0.5,
        ),
        labelSmall: const TextStyle(
          fontSize: 10.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 10.0 / 14.0,
          letterSpacing: 0.5,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 16.0 / 24.0,
          letterSpacing: 0.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 14.0 / 20.0,
          letterSpacing: 0.25,
        ),
        bodySmall: const TextStyle(
          fontSize: 10.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 16.0 / 10.0,
        ),
      ).apply(fontFamily: fontFamily, color: color, overFlow: overflow);

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  @override
  AppTextTheme copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
  }) {
    return AppTextTheme._(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
    );
  }

  AppTextTheme apply({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color? color,
    Color? bodyColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overFlow,
  }) {
    return AppTextTheme._(
      displayLarge: displayLarge.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      displayMedium: displayMedium.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      displaySmall: displaySmall.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      headlineLarge: headlineLarge.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      headlineMedium: headlineMedium.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      headlineSmall: headlineSmall.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      titleLarge: titleLarge.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      titleMedium: titleMedium.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      titleSmall: titleSmall.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      labelLarge: labelLarge.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      labelMedium: labelMedium.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      labelSmall: labelSmall.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      bodyLarge: bodyLarge.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      bodyMedium: bodyMedium.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
      bodySmall: bodySmall.apply(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
        overflow: overFlow,
        package: package,
      ),
    );
  }

  @override
  AppTextTheme lerp(
    covariant AppTextTheme? other,
    double t,
  ) {
    if (other is! AppTextTheme) {
      return this;
    }

    return AppTextTheme._(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
    );
  }
}
