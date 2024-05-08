import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'string_extension.dart';

extension TextEditingControllerExtension on TextEditingController {
  String? cannotEmpty({
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      return context.locale.cannotBeEmpty;
    }

    return null;
  }

  String? validateEmail({
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      return context.locale.cannotBeEmpty;
    }

    if (!text.isEmail) {
      return context.locale.invalidEmail;
    }

    return null;
  }

  String? validatePassword({
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      return context.locale.cannotBeEmpty;
    }

    // if (text.length < 6) {
    //   return context.locale.passwordsMustBe6Characters;
    // }

    // if (!text.isContainsLetter) {
    //   return context.locale.passwordMustContainLetter;
    // }

    // if (!text.isContainsNumber) {
    //   return context.locale.passwordMustContainNumber;
    // }

    return null;
  }

  String? validateConfirmPassword({
    required BuildContext context,
    required String anotherPassword,
  }) {
    if (text.isEmpty) {
      return context.locale.cannotBeEmpty;
    }

    if (text != anotherPassword) {
      return context.locale.passwordsDoNotMatch;
    }

    return null;
  }
}
