import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class AppBottomNavItem extends StatelessWidget {
  final BottomNavigationItem item;
  final Color iconColor;
  final Color labelColor;
  final EdgeInsetsGeometry? padding;
  final Function(BottomNavigationItem item) onTap;

  const AppBottomNavItem({
    super.key,
    required this.item,
    required this.iconColor,
    required this.labelColor,
    this.padding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () => onTap(item),
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
              item.iconPath,
              semanticsLabel: item.label(context),
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              item.label(context),
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
