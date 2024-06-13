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

  String? validateName({
    required BuildContext context,
    bool? isRequired,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    if (text.length < 3) {
      return context.locale.minimumLength(3);
    }

    if (text.length > 125) {
      return context.locale.maximumLength(125);
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
    bool? isRequired,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
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
    bool? isRequired,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    if (!text.isKtp) {
      return context.locale.invalidEKtp;
    }

    return null;
  }

  String? validatePhoneNumber({
    required BuildContext context,
    bool? isRequired,
    bool? isCannotSameAs,
    String? anotherPhoneNumber,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    // validate only number
    if (text.isContainsLetter ||
        text.isContainsSpecialCharacter(
          isWithOutComma: true,
        )) {
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

    if (isCannotSameAs == true) {
      if (text == anotherPhoneNumber) {
        return context.locale.phoneNumberCannotSame;
      }
    }

    return null;
  }

  String? validateOnlyNumber({
    required BuildContext context,
    bool? isRequired,
    bool? isAllowComma,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    // validate only number
    if (text.isContainsLetter ||
        text.isContainsSpecialCharacter(
          isWithOutComma: isAllowComma,
        )) {
      return context.locale.onlyNumber;
    }

    return null;
  }

  String? cannotSameAs({
    required BuildContext context,
    required String anotherValue,
  }) {
    if (text == anotherValue) {
      return context.locale.account;
    }

    return null;
  }
}
