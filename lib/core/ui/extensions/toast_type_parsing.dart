import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'theme_data_extension.dart';

enum ToastType {
  error,
  success,
  warning,
}

extension ToastTypeParsing on ToastType {
  Color backgroundColor(BuildContext context) {
    final color = context.theme.appColorScheme;

    switch (this) {
      case ToastType.error:
        return color.errorContainer;
      case ToastType.success:
        return color.successContainer;
      case ToastType.warning:
        return color.warningContainer;
    }
  }

  Color get textColor {
    switch (this) {
      case ToastType.error:
        return Colors.white;
      case ToastType.success:
        return Colors.white;
      case ToastType.warning:
        return Colors.white;
    }
  }
}
