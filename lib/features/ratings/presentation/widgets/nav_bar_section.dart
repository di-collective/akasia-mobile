import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/chips/choice_chip_widget.dart';
import '../cubit/nav_bar/nav_bar_state.dart';

class NavBarSection extends StatefulWidget {
  final List<NavBarItem> items;
  final NavBarItem selectedItem;
  final Function(int) onTap;
  final Function(double)? onHeightMeasured;

  const NavBarSection({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
    this.onHeightMeasured,
  });

  @override
  State<StatefulWidget> createState() => _NavBarSectionState();
}

class _NavBarSectionState extends State<NavBarSection> {
  final _mKey = GlobalKey();
  double? _lastMeasuredHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    SchedulerBinding.instance.addPostFrameCallback(_onMeasureHeight);
    return ClipRect(
      key: _mKey,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: Container(
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
            children: widget.items.mapIndexed((index, item) {
              return _NavBarChip(
                item: item,
                isSelected: widget.selectedItem == item,
                onTap: () => widget.onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onMeasureHeight(_) {
    final context = _mKey.currentContext;
    if (context == null) return;
    final currentHeight = context.size?.height;
    if (currentHeight == null || currentHeight == _lastMeasuredHeight) return;
    _lastMeasuredHeight = currentHeight;
    widget.onHeightMeasured?.call(currentHeight);
  }
}

class _NavBarChip extends StatelessWidget {
  final NavBarItem item;
  final bool isSelected;
  final Function() onTap;

  const _NavBarChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return ChoiceChipWidget(
      label: switch (item) {
        NavBarItem.recentlyReviewed => locale.recentlyReviewed,
        NavBarItem.myReview => locale.myReview
      },
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}


