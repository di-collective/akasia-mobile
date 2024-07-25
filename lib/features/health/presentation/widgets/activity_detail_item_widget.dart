import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import '../../../../core/ui/theme/text_theme.dart';

class ActivityDetailItemWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String? title;
  final Widget? titleWidget;
  final String description;

  const ActivityDetailItemWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    this.title,
    this.titleWidget,
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
            child: _buildTitle(
              colorScheme: colorScheme,
              textTheme: textTheme,
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

  Widget _buildTitle({
    required AppColorScheme colorScheme,
    required AppTextTheme textTheme,
  }) {
    if (titleWidget != null) {
      return titleWidget!;
    }

    if (title != null) {
      return Text(
        title!,
        style: textTheme.titleSmall.copyWith(
          color: colorScheme.onSurfaceDim,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  BorderRadius get _borderRadius {
    return BorderRadius.vertical(
      top: Radius.circular(isFirst ? 16 : 0),
      bottom: Radius.circular(isLast ? 16 : 0),
    );
  }
}
