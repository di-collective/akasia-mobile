import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../cubit/nav_bar/nav_bar_state.dart';

class NavBarSection extends StatelessWidget {
  final List<NavBarItem> items;
  final NavBarItem selectedItem;
  final Function(NavBarItem) onUpdateSelectedItem;

  const NavBarSection({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onUpdateSelectedItem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.outlineBright,
          ),
        ),
      ),
      child: Wrap(
        spacing: 12,
        children: items.map((item) {
          return _NavBarChip(
            item: item,
            isSelected: selectedItem == item,
            onSelected: onUpdateSelectedItem,
          );
        }).toList(),
      ),
    );
  }
}

class _NavBarChip extends StatelessWidget {
  final NavBarItem item;
  final bool isSelected;
  final Function(NavBarItem) onSelected;

  const _NavBarChip({
    required this.item,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final chipTheme = context.theme.chipTheme;
    final locale = context.locale;

    return ChoiceChip(
      label: Text(switch (item) {
        NavBarItem.recentlyReviewed => locale.recentlyReviewed,
        NavBarItem.myReview => locale.myReview
      }),
      showCheckmark: false,
      selected: isSelected,
      onSelected: (s) => onSelected(item),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      labelStyle: chipTheme.labelStyle
          ?.copyWith(color: isSelected ? colorScheme.primary : colorScheme.onSurface),
      shape: chipTheme.shape?.copyWith(
          side: BorderSide(
              color: isSelected ? colorScheme.primary : colorScheme.surfaceDim, width: 1)),
    );
  }
}
