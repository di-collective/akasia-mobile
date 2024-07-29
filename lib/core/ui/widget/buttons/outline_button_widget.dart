import 'package:flutter/material.dart';

import '../../theme/color_scheme.dart';
import 'button_widget.dart';

class OutlineButtonWidget extends ButtonWidget {
  final AppColorScheme? colorScheme;

  OutlineButtonWidget({
    super.key,
    super.child,
    super.onTap,
    super.overlayColor,
    super.elevation,
    super.isLoading,
    super.isDisabled,
    super.isUseShimmerLoading,
    super.text,
    super.height,
    super.width,
    super.borderRadius,
    super.padding,
    super.style,
    this.colorScheme,
    Color? textColor,
    Color? borderColor,
    Color? backgroundColor,
  }) : super(
          borderColor: borderColor ?? colorScheme?.surfaceDim,
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor: textColor ?? colorScheme?.onSurface,
        );
}
