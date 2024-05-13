import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class AppBottomNavItem extends StatelessWidget {
  const AppBottomNavItem({
    super.key,
    required this.itemData,
    required this.iconColor,
    required this.labelColor,
    this.padding,
    required this.onTap,
  });

  final AppBottomNavItemData itemData;
  final Color iconColor;
  final Color labelColor;
  final EdgeInsetsGeometry? padding;
  final Function(int? index) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () => onTap(itemData.index),
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 6.0,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              itemData.iconAssetName,
              semanticsLabel: itemData.label,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              itemData.label,
              style: context.theme.appTextTheme.bodySmall.copyWith(
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNavItemData {
  const AppBottomNavItemData({
    this.index,
    required this.label,
    required this.iconAssetName,
  });

  final int? index;
  final String label;
  final String iconAssetName;
}
