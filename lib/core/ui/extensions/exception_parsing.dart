import 'package:flutter/services.dart';

extension ExceptionParsing on Exception {
  String get errorMessage {
    String? message;
    if (this is PlatformException) {
      message = (this as PlatformException).message;
    }

    message ??= toString();

    if (message.contains('Exception: ')) {
      // remove 'Exception: '
      return message.replaceAll('Exception: ', '');
    }

    return message;
  }
}
