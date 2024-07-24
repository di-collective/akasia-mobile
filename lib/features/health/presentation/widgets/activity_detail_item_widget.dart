import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ActivityDetailItemWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String title;
  final String description;

  const ActivityDetailItemWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: _borderRadius,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.titleSmall.copyWith(
                color: colorScheme.onSurfaceDim,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            description,
            style: textTheme.titleSmall.copyWith(
              color: colorScheme.onSurfaceBright,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get _borderRadius {
    return BorderRadius.vertical(
      top: Radius.circular(isFirst ? 16 : 0),
      bottom: Radius.circular(isLast ? 16 : 0),
    );
  }
}
