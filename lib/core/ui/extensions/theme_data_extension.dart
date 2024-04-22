import 'package:flutter/material.dart';

import '../theme/color_scheme.dart';
import '../theme/text_theme.dart';

extension ThemeDataExtension on ThemeData {
  AppColorScheme get appColorScheme => extension<AppColorScheme>()!;

  AppTextTheme get appTextTheme => extension<AppTextTheme>()!;
}
