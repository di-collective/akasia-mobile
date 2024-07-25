import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/asset_path.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';

class TextFormWidget extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final String? prefixText;
  final Function()? onTapPrefixText;
  final Widget? suffixIcon;
  final String? suffixText;
  final Function()? onTapSuffixText;
  final bool? readOnly, isRequired, isLoading, autofocus;
  final String? initialValue;
  final Color? backgroundColor, textColor;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onClear;
  final String? description;

  const TextFormWidget({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textAlign,
    this.validator,
    this.prefixIcon,
    this.prefixText,
    this.onTapPrefixText,
    this.suffixIcon,
    this.suffixText,
    this.onTapSuffixText,
    this.readOnly,
    this.initialValue,
    this.backgroundColor,
    this.textColor,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.borderRadius,
    this.contentPadding,
    this.onTap,
    this.onEditingComplete,
    this.onClear,
    this.isRequired,
    this.isLoading,
    this.autofocus,
    this.description,
  });

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.keyboardType == TextInputType.visiblePassword;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text.rich(
            TextSpan(
              text: widget.title,
              children: [
                if (widget.isRequired == true)
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
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              initialValue: widget.initialValue,
              textAlign: widget.textAlign ?? TextAlign.start,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly ?? false,
              autofocus: widget.autofocus ?? false,
              focusNode: widget.focusNode,
              onChanged: _onChange,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              onTap: widget.onTap,
              onEditingComplete: widget.onEditingComplete,
              obscureText: _obscureText,
              style: textStyle(
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              cursorColor: colorScheme.primary,
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor: fillColor(colorScheme),
                filled: true,
                isDense: true,
                isCollapsed: true,
                prefixIcon: _buildPrefixIcon(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                suffixIcon: _buildSuffixIcon(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                hintStyle: textTheme.bodyLarge.copyWith(
                  color: colorScheme.onSurfaceBright,
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
                contentPadding: _buildContentPadding,
                errorBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.error,
                ),
                focusedErrorBorder: _buildOutlineInputBorder(
                  borderColor: colorScheme.primaryContainer,
                ),
                errorStyle: textTheme.bodySmall.copyWith(
                  color: colorScheme.error,
                ),
                errorMaxLines: 5,
              ),
              validator: widget.validator,
            ),
            if (widget.isLoading == true) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
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
          ],
        ),
        if (widget.description != null && widget.description!.isNotEmpty) ...[
          const SizedBox(
            height: 3,
          ),
          Text(
            "${widget.description!}.",
            style: textTheme.bodySmall.copyWith(
              color: colorScheme.onSurfaceBright,
            ),
            maxLines: 4,
          ),
        ],
      ],
    );
  }

  Color? fillColor(AppColorScheme colorScheme) {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor;
    }

    if (widget.readOnly == true) {
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
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    if (widget.readOnly == true) {
      return colorScheme.onSurfaceBright;
    }

    return colorScheme.onSurface;
  }

  EdgeInsetsGeometry get _buildContentPadding {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    final screenHeightType = context.screenHeightType;
    switch (screenHeightType) {
      case ScreenHeightType.small:
      case ScreenHeightType.medium:
        return const EdgeInsets.fromLTRB(
          12,
          10,
          12,
          14,
        );
      case ScreenHeightType.large:
        return const EdgeInsets.fromLTRB(
          12,
          14,
          12,
          14,
        );
    }
  }

  Widget? _buildPrefixIcon({
    required AppColorScheme colorScheme,
    required AppTextTheme textTheme,
  }) {
    if (widget.prefixIcon != null) {
      return widget.prefixIcon!;
    }

    if (widget.prefixText != null && widget.prefixText!.isNotEmpty) {
      return InkWell(
        onTap: widget.onTapPrefixText,
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 10,
            top: 1,
            bottom: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(7),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.prefixText!,
                style: textTheme.bodyLarge.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return null;
  }

  Widget? _buildSuffixIcon({
    required AppColorScheme colorScheme,
    required AppTextTheme textTheme,
  }) {
    List<Widget> listSuffix = [];
    if (widget.onClear != null && widget.controller?.text.isNotEmpty == true) {
      listSuffix.add(
        GestureDetector(
          onTap: () {
            // close keyboard
            context.closeKeyboard;

            // clear text
            widget.controller?.clear();

            // reload
            setState(() {});

            // callback
            widget.onClear!();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: SvgPicture.asset(
              AssetIconsPath.icCloseCircle,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurfaceBright,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    }

    if (widget.suffixIcon != null) {
      listSuffix.add(
        widget.suffixIcon!,
      );
    }

    if (widget.suffixText != null && widget.suffixText!.isNotEmpty) {
      return InkWell(
        onTap: widget.onTapSuffixText,
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 1,
            top: 1,
            bottom: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(7),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.suffixText!,
                    style: textTheme.bodyLarge.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.onTapSuffixText != null) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      AssetIconsPath.icChevronDown,
                      height: 7,
                      width: 7,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (widget.keyboardType == TextInputType.visiblePassword) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: colorScheme.primary,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: listSuffix,
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({
    required Color borderColor,
  }) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }

  void _onChange(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }

    // reload
    setState(() {});
  }
}
