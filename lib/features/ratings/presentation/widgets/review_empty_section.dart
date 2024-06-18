import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ReviewEmptySection extends StatelessWidget {
  final String info;

  const ReviewEmptySection(
    this.info, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Center(
      child: Wrap(
        direction: Axis.vertical,
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            color: colorScheme.surfaceDim,
          ),
          Text(
            info,
            style: context.theme.appTextTheme.labelMedium.copyWith(
              color: colorScheme.onSurfaceBright,
            ),
          ),
        ],
      ),
    );
  }
}
