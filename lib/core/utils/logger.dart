import 'dart:developer';

import '../flavors/flavor_info.dart';
import '../flavors/flavor_type_extension.dart';
import 'service_locator.dart';

class Logger {
  // Blue
  static void info(
    String? message,
  ) {
    _showLog(
      message: "\x1B[34m$message\x1B[0m",
      name: "🥸",
    );
  }

  // Green
  static void success(
    String? message,
  ) {
    _showLog(
      message: "\x1B[32m$message\x1B[0m",
      name: "🤩",
    );
  }

  // Error
  static void error(
    String? message,
  ) {
    _showLog(
      message: "\x1B[31m$message\x1B[0m",
      name: "🤬",
    );
  }

  // Yellow
  static void warning(
    String? message,
  ) {
    _showLog(
      message: "\x1B[33m$message\x1B[0m",
      name: "😔",
    );
  }

  static void _showLog({
    required String message,
    required String name,
  }) {
    if (sl<FlavorInfo>().type == FlavorType.production) {
      return;
    }

    log(message, name: name);
  }
}
