import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'double_extension.dart';
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
    bool? isRequired,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    if (isRequired != true && text.isEmpty) {
      return null;
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

    if (isRequired != true && text.isEmpty) {
      return null;
    }

    if (text.length < 12) {
      // return context.locale.passwordsMustBeCharacters(12);
      return context.locale.passwordIsTooWeak;
    }

    if (text.length > 125) {
      return context.locale.maximumLength(125);
    }

    return null;
  }

  String? validateConfirmPassword({
    required BuildContext context,
    required String anotherPassword,
    bool? isRequired,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
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

    if (text.isNotEmpty) {
      if (!text.isKtp) {
        return context.locale.invalidEKtp;
      }
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
    double? minimumAmount,
  }) {
    if (isRequired == true) {
      if (text.isEmpty) {
        return context.locale.cannotBeEmpty;
      }
    }

    // contains space
    if (text.isContainsSpace) {
      return context.locale.onlyNumber;
    }

    // validate only number
    if (text.isContainsLetter ||
        text.isContainsSpecialCharacter(
          isWithOutComma: isAllowComma,
        )) {
      return context.locale.onlyNumber;
    }

    // minimum amount
    if (minimumAmount != null) {
      final amount = text.parseToDouble;
      if (amount != null) {
        if (amount < minimumAmount) {
          return context.locale.minimumAmount(
            minimumAmount.toString(),
          );
        }
      }
    }

    return null;
  }

  String? validateWeight({
    required BuildContext context,
    bool? isRequired,
    double? minimum,
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
      return context.locale.onlyNumber;
    }

    final amount = text.parseToDouble;
    if (amount != null) {
      // validate maximum amount
      if (amount > 999) {
        return context.locale.maximum(999);
      }

      // validate minimum amount
      if (minimum != null) {
        if (amount < minimum) {
          return context.locale.minimumAmount(
            minimum.parseToString(),
          );
        }
      }
    }

    return null;
  }

  String? validateHeight({
    required BuildContext context,
    required int maximum,
    bool? isRequired,
    double? minimum,
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
      return context.locale.onlyNumber;
    }

    final amount = text.parseToDouble;
    if (amount != null) {
      // validate maximum amount
      if (amount > maximum) {
        return context.locale.maximum(maximum);
      }

      // validate minimum amount
      if (minimum != null) {
        if (amount < minimum) {
          return context.locale.minimumAmount(
            minimum.parseToString(),
          );
        }
      }
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
