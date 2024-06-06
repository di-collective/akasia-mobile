import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ReviewEmptyContent extends StatelessWidget {
  final String info;

  const ReviewEmptyContent({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(color: colorScheme.surfaceDim),
            ),
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
