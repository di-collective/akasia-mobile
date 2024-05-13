import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import 'bottom_nav_item.dart';

class AppBottomNavBar extends StatelessWidget {
  final BottomNavigationItem selectedItem;
  final Function(BottomNavigationItem item) onTap;

  const AppBottomNavBar({
    super.key,
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppColorScheme colorScheme = context.theme.appColorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        color: colorScheme.onPrimary,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: BottomNavigationItem.values.map((item) {
              if (item == BottomNavigationItem.chatUs) {
                return Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval(
                          child: Material(
                            color: colorScheme.primary,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: colorScheme.outlinePrimary,
                                width: 1.5,
                              ),
                            ),
                            child: AppBottomNavItem(
                              item: item,
                              iconColor: colorScheme.onPrimary,
                              labelColor: colorScheme.onPrimary,
                              onTap: onTap,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final isSelected = selectedItem == item;

                return Expanded(
                  child: AppBottomNavItem(
                    item: item,
                    iconColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    labelColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    onTap: onTap,
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}
