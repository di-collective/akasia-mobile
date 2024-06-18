import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class ChoiceChipWidget extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? leadingIcon;
  final bool isSelected;
  final Color? selectedContentColor;
  final Color? selectedBackgroundColor;
  final OutlinedBorder? shape;
  final Function() onTap;

  const ChoiceChipWidget({
    super.key,
    required this.label,
    this.labelStyle,
    this.padding,
    this.leadingIcon,
    required this.isSelected,
    this.selectedContentColor,
    this.selectedBackgroundColor,
    this.shape,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipTheme = context.theme.chipTheme;
    final colorScheme = context.theme.appColorScheme;
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      labelPadding: leadingIcon != null ? const EdgeInsets.only(left: 8) : EdgeInsets.zero,
      labelStyle: (labelStyle ?? chipTheme.labelStyle)?.copyWith(
        color: isSelected ? selectedContentColor ?? colorScheme.primary : colorScheme.onSurface,
      ),
      padding: padding ?? chipTheme.padding,
      backgroundColor: isSelected ? selectedBackgroundColor ?? colorScheme.primaryTonal : null,
      shape: (shape ?? chipTheme.shape)?.copyWith(
        side: BorderSide(
          color: isSelected ? selectedContentColor ?? colorScheme.primary : colorScheme.surfaceDim,
          width: 1,
        ),
      ),
      avatar: leadingIcon,
    );
  }
}
