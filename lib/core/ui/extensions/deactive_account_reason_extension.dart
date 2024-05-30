import 'package:flutter/material.dart';

import 'build_context_extension.dart';

enum DeactiveAccountReason {
  notUseful,
  tooExpensive,
  switchingToAn,
  other,
}

extension DeactiveAccountReasonExtension on DeactiveAccountReason {
  String title({
    required BuildContext context,
  }) {
    switch (this) {
      case DeactiveAccountReason.notUseful:
        return context.locale.notUseful;
      case DeactiveAccountReason.tooExpensive:
        return context.locale.tooExpensive;
      case DeactiveAccountReason.switchingToAn:
        return context.locale.switchingToAn;
      case DeactiveAccountReason.other:
        return context.locale.other;
    }
  }
}
