import 'package:flutter/material.dart';

import '../../common/exception.dart';
import 'build_context_extension.dart';
import 'exception_extension.dart';

extension CustomExceptionExtension on AppException {
  String errorMessage(BuildContext context) {
    if (this is AppNetworkException) {
      return context.locale.noInternetConnection;
    } else if (this is AppHttpException) {
      if (code != null) {
        if (code is Exception) {
          return (code as Exception).errorMessage;
        } else if (code is AppUnexpectedException) {
          final message = (code as AppUnexpectedException).message;
          if (message != null && message.isNotEmpty) {
            return message.toString();
          }

          return code.toString();
        } else {
          return code.toString();
        }
      }
    } else if (this is AuthException) {
      if (code == 'invalid-credential') {
        return context.locale.invalidCredential;
      } else if (code == 'not-registered') {
        return context.locale.notRegistered;
      } else if (code == 'already-registered') {
        return context.locale.alreadyRegistered;
      }
    }

    if (message != null && message!.isNotEmpty) {
      return message.toString();
    } else if (code != null) {
      return code.toString();
    }

    return toString();
  }
}
