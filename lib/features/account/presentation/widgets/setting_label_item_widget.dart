import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class SettingLabelItemWidget extends StatelessWidget {
  final String title;

  const SettingLabelItemWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title.toUpperCase(),
        style: textTheme.bodyMedium.copyWith(
          color: colorScheme.onSurfaceBright,
        ),
      ),
    );
  }
}
