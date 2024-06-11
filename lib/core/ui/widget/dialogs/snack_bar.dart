import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class AppSnackBar {
  final BuildContext context;
  final String message;
  final Color backgroundColor, textColor;

  AppSnackBar._({
    required this.context,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  }) {
    final messenger = context.scaffoldMessenger;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(_snackBar);
  }

  factory AppSnackBar.success(
    BuildContext context, {
    required String message,
  }) {
    final colorScheme = context.theme.appColorScheme;
    return AppSnackBar._(
      context: context,
      message: message,
      backgroundColor: colorScheme.successContainer,
      textColor: colorScheme.onSuccess,
    );
  }

  factory AppSnackBar.error(
    BuildContext context, {
    required String message,
  }) {
    final colorScheme = context.theme.appColorScheme;
    return AppSnackBar._(
      context: context,
      message: message,
      backgroundColor: colorScheme.errorContainer,
      textColor: colorScheme.onError,
    );
  }

  factory AppSnackBar.warning(
    BuildContext context, {
    required String message,
  }) {
    final colorScheme = context.theme.appColorScheme;
    return AppSnackBar._(
      context: context,
      message: message,
      backgroundColor: colorScheme.warningContainer,
      textColor: colorScheme.onWarning,
    );
  }

  factory AppSnackBar.info(
    BuildContext context, {
    required String message,
  }) {
    final colorScheme = context.theme.appColorScheme;
    return AppSnackBar._(
      context: context,
      message: message,
      backgroundColor: colorScheme.onPrimaryContainer,
      textColor: colorScheme.surfaceBright,
    );
  }

  SnackBar get _snackBar {
    final textTheme = context.theme.appTextTheme;
    return SnackBar(
      content: Text(
        message,
        style: textTheme.labelMedium.copyWith(
          color: textColor,
        ),
        maxLines: 3,
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
    );
  }
}
