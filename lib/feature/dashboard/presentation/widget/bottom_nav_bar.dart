import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import 'bottom_nav_item.dart';
import 'package:flutter/material.dart';

@immutable
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  final int selectedIndex;
  final Function(int? index) onTap;
  final Iterable<AppBottomNavItemData> items;

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
            children: items.map((itemData) {
              if (itemData.index == null) {
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
                              side: BorderSide(color: colorScheme.outlinePrimary, width: 1.5),
                            ),
                            child: AppBottomNavItem(
                              itemData: itemData,
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
                bool isSelected = selectedIndex == itemData.index;
                return Expanded(
                  child: AppBottomNavItem(
                    itemData: itemData,
                    iconColor: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    labelColor: isSelected ? colorScheme.primary : colorScheme.onSurface,
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
