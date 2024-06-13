import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'theme_data_extension.dart';

enum ToastType {
  error,
  success,
  warning,
  info,
}

extension ToastTypeExtension on ToastType {
  Color backgroundColor(BuildContext context) {
    final color = context.theme.appColorScheme;

    switch (this) {
      case ToastType.error:
        return color.errorContainer;
      case ToastType.success:
        return color.successContainer;
      case ToastType.warning:
        return color.warningContainer;
      case ToastType.info:
        return color.onPrimaryContainer;
    }
  }

  Color textColor(BuildContext context) {
    final color = context.theme.appColorScheme;

    switch (this) {
      case ToastType.error:
        return color.onError;
      case ToastType.success:
        return color.onSuccess;
      case ToastType.warning:
        return color.onWarning;
      case ToastType.info:
          return color.surfaceBright;
    }
  }
}
