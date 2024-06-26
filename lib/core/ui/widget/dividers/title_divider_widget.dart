import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class TitleDividerWidget extends StatelessWidget {
  final Color? color;
  final double? width;

  const TitleDividerWidget({
    super.key,
    this.color,
    this.width = 40,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: color ?? colorScheme.primary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
