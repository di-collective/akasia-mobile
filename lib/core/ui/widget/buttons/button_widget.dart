import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';
import '../loadings/shimmer_loading.dart';

class ButtonWidget extends StatelessWidget {
  final Color? textColor, borderColor, backgroundColor, overlayColor;
  final Function()? onTap;
  final Widget? child;
  final double? elevation;
  final bool? isLoading, isDisabled, isUseShimmerLoading;
  final String? text;
  final double? height, width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final TextAlign? textAlign;

  const ButtonWidget({
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
    this.isUseShimmerLoading,
    this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      height: _height,
      width: width,
      child: buttonWidget(
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),
    );
  }

  double? get _height {
    if (height != null) {
      return height;
    }

    return 48;
  }

  Widget buttonWidget({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    if (isLoading == true && isUseShimmerLoading == true) {
      return ShimmerLoading.circular(
        height: 48,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return ElevatedButton(
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
        overlayColor: MaterialStateProperty.all(
          overlayColor,
        ),
        padding: _padding,
        elevation: MaterialStateProperty.all(elevation ?? 0),
        backgroundColor: MaterialStateProperty.all(
          buttonBackgroundColor(colorScheme: colorScheme),
        ),
      ),
      child: buttonChild(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );
  }

  Widget? buttonChild({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    if (isLoading == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            color: buttonTextColor(
              colorScheme: colorScheme,
            ),
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    if (text != null) {
      return Text(
        text!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
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

  MaterialStateProperty<EdgeInsetsGeometry?>? get _padding {
    if (padding != null) {
      return MaterialStateProperty.all(padding);
    }

    return null;
  }
}
