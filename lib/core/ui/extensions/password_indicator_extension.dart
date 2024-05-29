import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'string_extension.dart';
import 'theme_data_extension.dart';

enum PasswordIndicator {
  weak,
  medium,
  strong,
}

extension PasswordIndicatorExtension on PasswordIndicator {
  String title({
    required BuildContext context,
  }) {
    switch (this) {
      case PasswordIndicator.weak:
        return context.locale.weak;
      case PasswordIndicator.medium:
        return context.locale.medium;
      case PasswordIndicator.strong:
        return context.locale.strong;
    }
  }

  Color color({
    required BuildContext context,
  }) {
    final color = context.theme.appColorScheme;

    switch (this) {
      case PasswordIndicator.weak:
      case PasswordIndicator.medium:
        return color.primary;
      case PasswordIndicator.strong:
        return color.success;
    }
  }

  static PasswordIndicator? parse(String password) {
    if (password.length < 12) {
      return null;
    } else if (password.length < 16) {
      if (password.isContainsNumber &&
          (password.isContainsUpperCase || password.isContainsLowerCase)) {
        return PasswordIndicator.medium;
      }

      return PasswordIndicator.weak;
    } else if (password.length == 16) {
      if (password.isContainsNumber &&
          (password.isContainsUpperCase || password.isContainsLowerCase)) {
        return PasswordIndicator.strong;
      }

      return PasswordIndicator.medium;
    } else if (password.length > 16) {
      return PasswordIndicator.strong;
    }

    return null;
  }
}
