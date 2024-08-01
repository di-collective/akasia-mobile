import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/asset_path.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';
import '../loadings/shimmer_loading.dart';

class DropdownWidget<T> extends StatelessWidget {
  final String? title, hintText;
  final List<DropdownMenuItem<T>>? items;
  final Function(T? value) onChanged;
  final String? Function(dynamic value)? validate;
  final T? selectedValue;
  final BorderRadius? borderRadius, borderRadiusMenu;
  final EdgeInsetsGeometry? contentPadding;
  final List<Widget> selectedItemBuilder;
  final bool? isDisabled, isLoading, isRequired;
  final Color? backgroundColor;
  final double? itemHeight;
  final TextStyle? titleTextStyle;

  const DropdownWidget({
    super.key,
    this.title,
    this.hintText,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    this.validate,
    this.borderRadius,
    this.borderRadiusMenu,
    this.contentPadding,
    required this.selectedItemBuilder,
    this.isDisabled,
    this.isLoading,
    this.isRequired,
    this.backgroundColor,
    this.itemHeight,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text.rich(
            TextSpan(
              text: title,
              children: [
                if (isRequired == true)
                  TextSpan(
                    text: ' *',
                    style: titleStyle(
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ).copyWith(
                      color: colorScheme.error,
                    ),
                  ),
              ],
              style: titleStyle(
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        Stack(
          children: [
            DropdownButtonFormField2(
              value: selectedValue,
              hint: (hintText == null)
                  ? null
                  : Text(
                      hintText!,
                      style: textTheme.bodyLarge.copyWith(
                        color: colorScheme.onSurfaceBright,
                      ),
                    ),
              style: textStyle(
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              items: items,
              onChanged: onChanged,
              validator: validate,
              selectedItemBuilder: (context) {
                return selectedItemBuilder;
              },
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.zero,
                height: itemHeight ?? kMinInteractiveDimension,
              ),
              dropdownStyleData: DropdownStyleData(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: borderRadiusMenu ?? BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(
                  AssetIconsPath.icChevronDown,
                ),
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: fillColor(colorScheme),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                prefixIcon: const SizedBox(
                  width: 12,
                ),
                border: _buildOutlineInputBorder(
                  borderColor: colorScheme.surfaceDim,
                ),
                enabledBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.surfaceDim,
                ),
                focusedBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.primaryContainer,
                ),
                errorBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.surfaceDim,
                ),
                focusedErrorBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.primaryContainer,
                ),
                errorStyle: textTheme.bodySmall.copyWith(
                  color: colorScheme.error,
                ),
                errorMaxLines: 5,
                contentPadding: _contentPadding,
              ),
            ),
            if (isLoading == true) ...[
              Positioned.fill(
                child: ShimmerLoading.circular(
                  width: context.width,
                  height: context.height,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ],
            if (isDisabled == true) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }

  TextStyle titleStyle({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    if (titleTextStyle != null) {
      return titleTextStyle!;
    }

    return textTheme.labelMedium.copyWith(
      color: colorScheme.onSurface,
    );
  }

  Color? fillColor(AppColorScheme colorScheme) {
    if (backgroundColor != null) {
      return backgroundColor;
    }

    if (isDisabled == true) {
      return colorScheme.surface;
    }

    return Colors.white;
  }

  TextStyle textStyle({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    return textTheme.bodyLarge.copyWith(
      color: textColor(colorScheme: colorScheme),
    );
  }

  Color textColor({
    required AppColorScheme colorScheme,
  }) {
    if (isDisabled == true) {
      return colorScheme.onSurfaceBright;
    }

    return colorScheme.onSurface;
  }

  OutlineInputBorder _buildOutlineInputBorder({
    required Color borderColor,
  }) {
    return OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }

  BorderRadius get _borderRadius {
    return borderRadius ?? BorderRadius.circular(8);
  }

  EdgeInsetsGeometry get _contentPadding {
    if (contentPadding != null) {
      return contentPadding!;
    }

    return const EdgeInsets.fromLTRB(
      0,
      13.5,
      0,
      8,
    );
  }
}
