import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';

class ButtonWidget extends StatelessWidget {
  final Color? textColor, borderColor, backgroundColor;
  final Function()? onTap;
  final Widget? child;
  final double? elevation;
  final bool? isLoading, isDisabled;
  final String? text;
  final double? height, width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;

  const ButtonWidget({
    super.key,
    this.child,
    this.onTap,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
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
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (isDisabled == true) {
            return;
          }

          if (onTap == null) {
            return;
          }

          if (isLoading == true) {
            return;
          }

          onTap!();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              side: borderSide(
                colorScheme: colorScheme,
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
            padding ?? const EdgeInsets.all(18),
          ),
          elevation: MaterialStateProperty.all(elevation ?? 0),
          backgroundColor: MaterialStateProperty.all(
            buttonBackgroundColor(colorScheme: colorScheme),
          ),
        ),
        child: buttonChild(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ),
    );
  }

  Widget? buttonChild({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    if (isLoading == true) {
      return SizedBox(
        height: 11,
        width: 11,
        child: CircularProgressIndicator(
          color: buttonTextColor(
            colorScheme: colorScheme,
          ),
          strokeWidth: 1.5,
        ),
      );
    }

    if (text != null) {
      return Text(
        text!,
        style: style ??
            textTheme.bodyLarge.copyWith(
              color: buttonTextColor(
                colorScheme: colorScheme,
              ),
              fontWeight: FontWeight.w600,
            ),
      );
    }

    return child;
  }

  Color buttonTextColor({
    required AppColorScheme colorScheme,
  }) {
    if (textColor != null) {
      return textColor!;
    }

    if (isDisabled == true) {
      return colorScheme.onSurfaceBright;
    }

    return colorScheme.onPrimary;
  }

  Color buttonBackgroundColor({
    required AppColorScheme colorScheme,
  }) {
    if (isDisabled == true) {
      return colorScheme.surface;
    }

    if (backgroundColor != null) {
      return backgroundColor!;
    }

    return colorScheme.primary;
  }

  BorderSide borderSide({
    required AppColorScheme colorScheme,
  }) {
    if (isDisabled == true) {
      return BorderSide(
        color: colorScheme.surfaceDim,
      );
    }

    if (borderColor != null) {
      return BorderSide(
        color: borderColor!,
      );
    }

    return BorderSide.none;
  }
}
