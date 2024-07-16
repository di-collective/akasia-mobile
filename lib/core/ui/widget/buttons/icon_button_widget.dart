import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class IconButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final Widget icon;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Color? rippleColor, backgroundColor;

  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.padding,
    this.shape,
    this.rippleColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      padding: padding ?? const EdgeInsets.all(8),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        ),
        overlayColor: MaterialStateProperty.all(
          rippleColor ?? colorScheme.outlinePrimary,
        ),
        backgroundColor: MaterialStateProperty.all(
          backgroundColor ?? colorScheme.white,
        ),
      ),
    );
  }
}
