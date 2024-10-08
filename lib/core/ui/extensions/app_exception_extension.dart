import 'package:flutter/material.dart';

import '../../common/exception.dart';
import '../../network/http/dio_interceptor.dart';
import 'build_context_extension.dart';
import 'exception_extension.dart';

enum AppExceptionType {
  accessTokenNotFound,
}

extension AppExceptionExtension on AppException {
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
        } else if (code is NotFoundException) {
          return "Data not found";
        } else {
          return code.toString();
        }
      }
    } else if (this is AuthException) {
      if (code == AppExceptionType) {
        switch (code) {
          case AppExceptionType.accessTokenNotFound:
            return context.locale.invalidCredential;
        }
      }

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
