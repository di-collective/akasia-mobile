import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';

class CategoryItemWidget extends StatelessWidget {
  final String iconPath;
  final String title;

  const CategoryItemWidget({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      width: context.width / 4.5,
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(
                AppRadius.extraSmall,
              ),
            ),
            child: SvgPicture.asset(
              iconPath,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
