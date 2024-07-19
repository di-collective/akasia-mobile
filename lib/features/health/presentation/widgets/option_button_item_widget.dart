import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class OptionButtonItemWidget extends StatelessWidget {
  final String title;
  final BorderRadius? borderRadius;
  final Function() onTap;

  const OptionButtonItemWidget({
    super.key,
    required this.title,
    this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Material(
      color: colorScheme.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: context.width,
          child: Text(
            title,
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurfaceDim,
            ),
          ),
        ),
      ),
    );
  }
}
