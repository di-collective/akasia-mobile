import 'package:akasia365mc/core/ui/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class SettingItemWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget? iconWidget;
  final Function()? onTap;

  const SettingItemWidget({
    super.key,
    required this.title,
    this.titleColor,
    this.iconWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          context.paddingHorizontal,
          18,
          22,
          18,
        ),
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
              title.toCapitalizes(),
              style: textTheme.labelMedium.copyWith(
                color: titleColor ?? colorScheme.onSurfaceDim,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (iconWidget != null) ...[
              iconWidget!,
            ] else ...[
              SvgPicture.asset(
                AssetIconsPath.icArrowRight,
                height: 10,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceBright,
                  BlendMode.srcIn,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
