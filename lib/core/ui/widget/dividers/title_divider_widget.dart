import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class TitleDividerWidget extends StatelessWidget {
  const TitleDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
