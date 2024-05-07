import 'package:flutter/material.dart';

import '../../common/exception.dart';
import 'app_exception_parsing.dart';
import 'exception_parsing.dart';

extension ObjectParsing on Object {
  String message(BuildContext context) {
    if (this is Exception) {
      return (this as Exception).message;
    } else if (this is AppException) {
      return (this as AppException).errorMessage(context);
    }

    return toString();
  }
}
