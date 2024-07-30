import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class SettingItemWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Function() onTap;

  const SettingItemWidget({
    super.key,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineBright,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.labelLarge.copyWith(
                color: titleColor ?? colorScheme.onSurfaceDim,
                fontWeight: FontWeight.w500,
              ),
            ),
            SvgPicture.asset(
              AssetIconsPath.icChevronRight,
              height: 10,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurfaceBright,
                BlendMode.srcIn,
              ),
            )
          ],
        ),
      ),
    );
  }
}
