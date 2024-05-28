import 'package:flutter/material.dart';

import '../../common/exception.dart';
import 'app_exception_extension.dart';
import 'exception_extension.dart';

extension ObjectExtension on Object {
  String message(BuildContext context) {
    if (this is Exception) {
      return (this as Exception).errorMessage;
    } else if (this is AppException) {
      return (this as AppException).errorMessage(context);
    }

    return toString();
  }
}
