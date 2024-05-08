import 'package:flutter/material.dart';

import '../../common/exception.dart';
import 'build_context_extension.dart';
import 'exception_parsing.dart';

extension CustomExceptionParsing on AppException {
  String errorMessage(BuildContext context) {
    if (message != null && message!.isNotEmpty) {
      return message.toString();
    }

    if (this is AppNetworkException) {
      return context.locale.noInternetConnection;
    } else if (this is AppHttpException) {
      if (code != null) {
        if (code is Exception) {
          return (code as Exception).message;
        }

        return code.toString();
      }
    } else if (code != null) {
      return code.toString();
    }

    return toString();
  }
}
