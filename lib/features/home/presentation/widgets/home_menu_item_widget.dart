import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';

class HomeMenuItemWidget extends StatelessWidget {
  final String iconSvgPath;
  final String title;
  final Function() onTap;

  const HomeMenuItemWidget({
    super.key,
    required this.iconSvgPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Material(
      color: colorScheme.white,
      child: InkWell(
        onTap: onTap,
        overlayColor: MaterialStateProperty.all(colorScheme.primaryTonal),
        borderRadius: BorderRadius.circular(
          AppRadius.medium,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: SizedBox(
            width: context.width * 0.22,
            child: Column(
              children: [
                SvgPicture.asset(
                  iconSvgPath,
                  height: 40,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title.toCapitalizes(),
                  style: textTheme.bodySmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
