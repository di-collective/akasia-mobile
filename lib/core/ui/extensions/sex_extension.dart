import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'string_extension.dart';

enum SexType {
  male,
  female,
}

extension SexTypeExtension on SexType {
  String title({
    required BuildContext? context,
  }) {
    switch (this) {
      case SexType.female:
        return context?.locale.male ?? "Male";
      case SexType.male:
        return context?.locale.female ?? "Female";
    }
  }

  static SexType? fromString(String? value) {
    if (value == null) {
      return null;
    }

    return SexType.values.firstWhereOrNull(
      (element) => element.name.isSame(otherValue: value),
    );
  }
}
