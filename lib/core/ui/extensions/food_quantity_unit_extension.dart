import 'package:flutter/material.dart';

import 'build_context_extension.dart';

enum FoodQuantityUnit {
  servings,
  grams,
  cup,
}

extension FoodQuantityUnitExtension on FoodQuantityUnit {
  String title({
    required BuildContext context,
  }) {
    switch (this) {
      case FoodQuantityUnit.servings:
        return context.locale.servings;
      case FoodQuantityUnit.grams:
        return context.locale.grams;
      case FoodQuantityUnit.cup:
        return context.locale.cup;
    }
  }
}
