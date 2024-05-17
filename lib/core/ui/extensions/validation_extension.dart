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

    if (text.length < 12) {
      return context.locale.passwordsMustBeCharacters(12);
    }

    if (text.length > 125) {
      return context.locale.maximumLength(125);
    }

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

  String? validateKtp({
    required BuildContext context,
  }) {
    // validate only number
    if (text.isContainsLetter || text.isContainsSpecialCharacter) {
      return context.locale.invalidEKtp;
    }

    if (text.length < 16) {
      return context.locale.minimumLength(16);
    }

    if (text.length > 16) {
      return context.locale.maximumLength(16);
    }

    return null;
  }

  String? validatePhoneNumber({
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      return context.locale.cannotBeEmpty;
    }

    // validate only number
    if (text.isContainsLetter || text.isContainsSpecialCharacter) {
      return context.locale.invalidPhoneNumber;
    }

    // cannot start with 0
    if (text.startsWith('0')) {
      return context.locale.phoneNumberCannotStartWithZero;
    }

    if (text.length < 9) {
      return context.locale.minimumLength(9);
    }

    if (text.length > 13) {
      return context.locale.maximumLength(13);
    }

    return null;
  }
}
