import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/config/asset_path.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';

class DropdownWidget<T> extends StatelessWidget {
  final String? title, hintText;
  final List<DropdownMenuItem<T>>? items;
  final Function(T? value) onChanged;
  final String? Function(dynamic value)? validate;
  final T? selectedValue;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final List<Widget> selectedItemBuilder;
  final bool? isDisabled, isLoading, isRequired;
  final Color? backgroundColor;
  final double? itemHeight;

  const DropdownWidget({
    super.key,
    this.title,
    this.hintText,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    this.validate,
    this.borderRadius,
    this.contentPadding,
    required this.selectedItemBuilder,
    this.isDisabled,
    this.isLoading,
    this.isRequired,
    this.backgroundColor,
    this.itemHeight,
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
                    style: textTheme.labelMedium.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
              ],
              style: textTheme.labelMedium,
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
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(
                  AssetIconsPath.icArrowDown,
                ),
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: fillColor(colorScheme),
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
                  borderColor: colorScheme.error,
                ),
                focusedErrorBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.primaryContainer,
                ),
                contentPadding: contentPadding ??
                    const EdgeInsets.fromLTRB(
                      12,
                      10,
                      12,
                      14,
                    ),
              ),
            ),
            if (isLoading == true) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: SizedBox(
                      height: 11,
                      width: 11,
                      child: CircularProgressIndicator(
                        color: textColor(
                          colorScheme: colorScheme,
                        ),
                        strokeWidth: 1.5,
                      ),
                    ),
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
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }
}
