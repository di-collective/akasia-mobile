import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../extensions/toast_type_parsing.dart';

abstract class ToastInfo {
  Future<bool?> show({
    required ToastType type,
    required String message,
    required BuildContext context,
  });
}

class ToastInfoImpl implements ToastInfo {
  @override
  Future<bool?> show({
    required ToastType type,
    required String message,
    required BuildContext context,
  }) async {
    // cancel all toasts before showing a new one
    await _cancelAllToasts();

    try {
      final textTheme = context.theme.appTextTheme;

      // show toast
      return await Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        backgroundColor: type.backgroundColor(context),
        textColor: type.textColor,
        fontSize: textTheme.labelMedium.fontSize,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> _cancelAllToasts() async {
    try {
      return await Fluttertoast.cancel();
    } catch (_) {
      rethrow;
    }
  }
}
