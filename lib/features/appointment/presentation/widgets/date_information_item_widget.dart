import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class DateInformationItemWidget extends StatelessWidget {
  final Color? dotBackgroundColor, dotBorderColor;
  final String title;

  const DateInformationItemWidget({
    super.key,
    this.dotBackgroundColor,
    this.dotBorderColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: dotBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: dotBorderColor ?? Colors.transparent,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              title,
              style: textTheme.bodySmall.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          )
        ],
      ),
    );
  }
}
