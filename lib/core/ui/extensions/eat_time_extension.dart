import 'package:flutter/material.dart';

import 'build_context_extension.dart';

enum EatTime {
  breakfast,
  lunch,
  dinner,
  snack,
}

extension EatTimeExtension on EatTime {
  String title({
    required BuildContext context,
  }) {
    switch (this) {
      case EatTime.breakfast:
        return context.locale.breakfast;
      case EatTime.lunch:
        return context.locale.lunch;
      case EatTime.dinner:
        return context.locale.dinner;
      case EatTime.snack:
        return context.locale.snacks;
    }
  }
}
