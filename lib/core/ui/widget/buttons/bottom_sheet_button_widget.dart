import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import 'package:flutter/material.dart';

import 'button_widget.dart';

class BottomSheetButtonWidget extends StatelessWidget {
  final Color? textColor, borderColor, backgroundColor, overlayColor;
  final Function()? onTap;
  final Widget? child;
  final double? elevation;
  final bool? isLoading, isDisabled;
  final String? text;
  final double? height, width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;

  const BottomSheetButtonWidget({
    super.key,
    this.child,
    this.onTap,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.overlayColor,
    this.elevation,
    this.isLoading,
    this.isDisabled,
    this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      color: colorScheme.onPrimary,
      padding: EdgeInsets.fromLTRB(
        context.paddingHorizontal,
        10,
        context.paddingHorizontal,
        context.paddingBottom,
      ),
      child: ButtonWidget(
        onTap: onTap,
        textColor: textColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        overlayColor: overlayColor,
        elevation: elevation,
        isLoading: isLoading,
        isDisabled: isDisabled,
        text: text,
        height: height,
        width: width,
        borderRadius: borderRadius,
        padding: padding,
        style: style,
        child: child,
      ),
    );
  }
}
