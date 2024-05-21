import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ProfileDetailItemWidget extends StatelessWidget {
  final String label;
  final String? value;

  const ProfileDetailItemWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.labelLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.width * 0.5,
            ),
            child: Text(
              value ?? '-',
              style: textTheme.labelLarge.copyWith(
                color: colorScheme.onSurfaceDim,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
