import 'package:flutter/material.dart';

import '../extensions/color_swatch_extension.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  AppColorScheme._({
    required this.primary,
    required this.onPrimary,
    required this.primaryTonal,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.surfaceBright,
    required this.onSurfaceBright,
    required this.surfaceContainerBright,
    required this.surfaceDim,
    required this.onSurfaceDim,
    required this.surfaceContainerDim,
    required this.outline,
    required this.outlineBright,
    required this.outlineDim,
    required this.outlinePrimary,
    required this.outlinePrimaryFocus,
    required this.scrim,
    required this.black,
    required this.white,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryTonal;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainer;
  final Color surfaceBright;
  final Color onSurfaceBright;
  final Color surfaceContainerBright;
  final Color surfaceDim;
  final Color onSurfaceDim;
  final Color surfaceContainerDim;
  final Color outline;
  final Color outlineBright;
  final Color outlineDim;
  final Color outlinePrimary;
  final Color outlinePrimaryFocus;
  final Color scrim;
  final Color black;
  final Color white;
  final ColorSwatch<AppColorSpec> vividTangelo = _AppColors.vividTangelo;
  final ColorSwatch<AppColorSpec> ao = _AppColors.ao;
  final ColorSwatch<AppColorSpec> coralRed = _AppColors.coralRed;
  final ColorSwatch<AppColorSpec> yellow = _AppColors.yellow;
  final ColorSwatch<AppColorSpec> neutral = _AppColors.neutral;
  final ColorSwatch<AppColorSpec> cola = _AppColors.cola;

  factory AppColorScheme.light() => AppColorScheme._(
        primary: _AppColors.vividTangelo,
        onPrimary: _AppColors.vividTangelo.tint10,
        primaryTonal: _AppColors.vividTangelo.tint40,
        primaryContainer: _AppColors.vividTangelo.shade20,
        onPrimaryContainer: _AppColors.vividTangelo.shade50,
        warning: _AppColors.yellow,
        onWarning: _AppColors.yellow.tint10,
        warningContainer: _AppColors.yellow.shade20,
        onWarningContainer: _AppColors.yellow.shade50,
        success: _AppColors.ao,
        onSuccess: _AppColors.ao.tint10,
        successContainer: _AppColors.ao.shade20,
        onSuccessContainer: _AppColors.ao.shade50,
        error: _AppColors.coralRed,
        onError: _AppColors.coralRed.tint10,
        errorContainer: _AppColors.coralRed.shade20,
        onErrorContainer: _AppColors.coralRed.shade50,
        surface: _AppColors.cola.tint30,
        onSurface: _AppColors.cola.tint90,
        surfaceContainer: _AppColors.vividTangelo.tint30,
        surfaceBright: _AppColors.cola.tint20,
        onSurfaceBright: _AppColors.cola.tint60,
        surfaceContainerBright: _AppColors.vividTangelo.tint20,
        surfaceDim: _AppColors.cola.tint40,
        onSurfaceDim: _AppColors.cola.tint100,
        surfaceContainerDim: _AppColors.vividTangelo.tint40,
        outline: _AppColors.neutral.tint80,
        outlineBright: _AppColors.neutral.tint60,
        outlineDim: _AppColors.neutral.tint100,
        outlinePrimary: _AppColors.vividTangelo.tint60,
        outlinePrimaryFocus: _AppColors.vividTangelo.shade20,
        scrim: const Color(0xAD2D2D2D),
        black: const Color(0xFF000000),
        white: _AppColors.neutral.tint10,
      );

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryTonal,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainer,
    Color? surfaceBright,
    Color? onSurfaceBright,
    Color? surfaceContainerBright,
    Color? surfaceDim,
    Color? onSurfaceDim,
    Color? surfaceContainerDim,
    Color? outline,
    Color? outlineBright,
    Color? outlineDim,
    Color? outlinePrimary,
    Color? outlinePrimaryFocus,
    Color? scrim,
    Color? black,
    Color? white,
  }) {
    return AppColorScheme._(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryTonal: primaryTonal ?? this.primaryTonal,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      onSurfaceBright: onSurfaceBright ?? this.onSurfaceBright,
      surfaceContainerBright:
          surfaceContainerBright ?? this.surfaceContainerBright,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      onSurfaceDim: onSurfaceDim ?? this.onSurfaceDim,
      surfaceContainerDim: surfaceContainerDim ?? this.surfaceContainerDim,
      outline: outline ?? this.outline,
      outlineBright: outlineBright ?? this.outlineBright,
      outlineDim: outlineDim ?? this.outlineDim,
      outlinePrimary: outlinePrimary ?? this.outlinePrimary,
      outlinePrimaryFocus: outlinePrimaryFocus ?? this.outlinePrimaryFocus,
      scrim: scrim ?? this.scrim,
      black: black ?? this.black,
      white: white ?? this.white,
    );
  }

  @override
  AppColorScheme lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) {
      return this;
    }

    return AppColorScheme._(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryTonal: Color.lerp(primaryTonal, other.primaryTonal, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer:
          Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      onSurfaceBright: Color.lerp(onSurfaceBright, other.onSurfaceBright, t)!,
      surfaceContainerBright:
          Color.lerp(surfaceContainerBright, other.surfaceContainerBright, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      onSurfaceDim: Color.lerp(onSurfaceDim, other.onSurfaceDim, t)!,
      surfaceContainerDim:
          Color.lerp(surfaceContainerDim, other.surfaceContainerDim, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineBright: Color.lerp(outlineBright, other.outlineBright, t)!,
      outlineDim: Color.lerp(outlineDim, other.outlineDim, t)!,
      outlinePrimary: Color.lerp(outlinePrimary, other.outlinePrimary, t)!,
      outlinePrimaryFocus:
          Color.lerp(outlinePrimaryFocus, other.outlinePrimaryFocus, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      black: Color.lerp(black, other.black, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }
}

abstract final class _AppColors {
  static const ColorSwatch<AppColorSpec> vividTangelo = ColorSwatch(
    0xFFF37021,
    {
      AppColorSpec.tint10: Color(0xFFFFFEFD),
      AppColorSpec.tint20: Color(0xFFFFF9F6),
      AppColorSpec.tint30: Color(0xFFFEF5EF),
      AppColorSpec.tint40: Color(0xFFFEEEE4),
      AppColorSpec.tint50: Color(0xFFFCDDCA),
      AppColorSpec.tint60: Color(0xFFFAC9AB),
      AppColorSpec.tint70: Color(0xFFF9B287),
      AppColorSpec.tint80: Color(0xFFF8A675),
      AppColorSpec.tint90: Color(0xFFF69459),
      AppColorSpec.tint100: Color(0xFFF3762A),
      AppColorSpec.shade10: Color(0xFFCA5D1C),
      AppColorSpec.shade20: Color(0xFFA24B16),
      AppColorSpec.shade30: Color(0xFF7A3811),
      AppColorSpec.shade40: Color(0xFF51250B),
      AppColorSpec.shade50: Color(0xFF311607),
    },
  );

  static const ColorSwatch<AppColorSpec> ao = ColorSwatch(
    0xFF007900,
    {
      AppColorSpec.tint10: Color(0xFFFCFEFC),
      AppColorSpec.tint20: Color(0xFFF5FAF5),
      AppColorSpec.tint30: Color(0xFFEDF6ED),
      AppColorSpec.tint40: Color(0xFFE0EFE0),
      AppColorSpec.tint50: Color(0xFFC2DFC2),
      AppColorSpec.tint60: Color(0xFF9ECC9E),
      AppColorSpec.tint70: Color(0xFF75B775),
      AppColorSpec.tint80: Color(0xFF61AC61),
      AppColorSpec.tint90: Color(0xFF409A40),
      AppColorSpec.tint100: Color(0xFF0A7E0A),
      AppColorSpec.shade10: Color(0xFF006500),
      AppColorSpec.shade20: Color(0xFF005100),
      AppColorSpec.shade30: Color(0xFF003D00),
      AppColorSpec.shade40: Color(0xFF002800),
      AppColorSpec.shade50: Color(0xFF001800),
    },
  );

  static const ColorSwatch<AppColorSpec> coralRed = ColorSwatch(
    0xFFF93D3D,
    {
      AppColorSpec.tint10: Color(0xFFFFFDFD),
      AppColorSpec.tint20: Color(0xFFFFF7F7),
      AppColorSpec.tint30: Color(0xFFFFF1F1),
      AppColorSpec.tint40: Color(0xFFFEE8E8),
      AppColorSpec.tint50: Color(0xFFFED0D0),
      AppColorSpec.tint60: Color(0xFFFDB5B5),
      AppColorSpec.tint70: Color(0xFFFC9696),
      AppColorSpec.tint80: Color(0xFFFB8787),
      AppColorSpec.tint90: Color(0xFFFB6E6E),
      AppColorSpec.tint100: Color(0xFFF94545),
      AppColorSpec.shade10: Color(0xFFCF3333),
      AppColorSpec.shade20: Color(0xFFA62929),
      AppColorSpec.shade30: Color(0xFF7D1F1F),
      AppColorSpec.shade40: Color(0xFF531414),
      AppColorSpec.shade50: Color(0xFF320C0C),
    },
  );

  static const ColorSwatch<AppColorSpec> yellow = ColorSwatch(
    0xFFFFCC00,
    {
      AppColorSpec.tint10: Color(0xFFFFFEFC),
      AppColorSpec.tint20: Color(0xFFFFFDF5),
      AppColorSpec.tint30: Color(0xFFFFFBED),
      AppColorSpec.tint40: Color(0xFFFFF9E0),
      AppColorSpec.tint50: Color(0xFFFFF3C2),
      AppColorSpec.tint60: Color(0xFFFFEC9E),
      AppColorSpec.tint70: Color(0xFFFFE375),
      AppColorSpec.tint80: Color(0xFFFFDF61),
      AppColorSpec.tint90: Color(0xFFFFD940),
      AppColorSpec.tint100: Color(0xFFFFCE0A),
      AppColorSpec.shade10: Color(0xFFD4AA00),
      AppColorSpec.shade20: Color(0xFFAA8800),
      AppColorSpec.shade30: Color(0xFF806600),
      AppColorSpec.shade40: Color(0xFF554400),
      AppColorSpec.shade50: Color(0xFF332900),
    },
  );

  static const ColorSwatch<AppColorSpec> neutral = ColorSwatch(
    0xFFDFE0DF,
    {
      AppColorSpec.tint10: Color(0xFFFFFFFF),
      AppColorSpec.tint20: Color(0xFFFEFEFE),
      AppColorSpec.tint30: Color(0xFFFDFDFD),
      AppColorSpec.tint40: Color(0xFFFBFBFB),
      AppColorSpec.tint50: Color(0xFFF7F8F7),
      AppColorSpec.tint60: Color(0xFFF3F3F3),
      AppColorSpec.tint70: Color(0xFFEEEEEE),
      AppColorSpec.tint80: Color(0xFFEBECEB),
      AppColorSpec.tint90: Color(0xFFE7E8E7),
      AppColorSpec.tint100: Color(0xFFE0E1E0),
      AppColorSpec.shade10: Color(0xFFB2B3B2),
      AppColorSpec.shade20: Color(0xFF9C9D9C),
      AppColorSpec.shade30: Color(0xFF868686),
      AppColorSpec.shade40: Color(0xFF707070),
      AppColorSpec.shade50: Color(0xFF595A59),
    },
  );

  static const ColorSwatch<AppColorSpec> cola = ColorSwatch(
    0xFF3F3126,
    {
      AppColorSpec.tint10: Color(0xFFFDFDFD),
      AppColorSpec.tint20: Color(0xFFF7F7F6),
      AppColorSpec.tint30: Color(0xFFF2F1F0),
      AppColorSpec.tint40: Color(0xFFE8E6E5),
      AppColorSpec.tint50: Color(0xFFD1CECB),
      AppColorSpec.tint60: Color(0xFFB6B1AD),
      AppColorSpec.tint70: Color(0xFF97908A),
      AppColorSpec.tint80: Color(0xFF887F78),
      AppColorSpec.tint90: Color(0xFF6F655C),
      AppColorSpec.tint100: Color(0xFF47392F),
      AppColorSpec.shade10: Color(0xFF352920),
      AppColorSpec.shade20: Color(0xFF2A2119),
      AppColorSpec.shade30: Color(0xFF201913),
      AppColorSpec.shade40: Color(0xFF15100D),
      AppColorSpec.shade50: Color(0xFF0D0A08),
    },
  );
}

enum AppColorSpec {
  tint10,
  tint20,
  tint30,
  tint40,
  tint50,
  tint60,
  tint70,
  tint80,
  tint90,
  tint100,
  shade10,
  shade20,
  shade30,
  shade40,
  shade50,
}
