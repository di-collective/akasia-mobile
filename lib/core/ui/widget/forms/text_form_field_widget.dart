import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final String? initialValue;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final bool? isDisabled;
  final Function()? onClear;
  final bool? isRequired;

  const TextFormFieldWidget({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textAlign,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.initialValue,
    this.backgroundColor,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.borderRadius,
    this.contentPadding,
    this.onTap,
    this.onEditingComplete,
    this.isDisabled,
    this.onClear,
    this.isRequired,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
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
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          textAlign: widget.textAlign ?? TextAlign.start,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly ?? false,
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
          cursorHeight: 18,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: fillColor(colorScheme),
            filled: true,
            isDense: true,
            isCollapsed: true,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(colorScheme),
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
            contentPadding:
                widget.hintText != null && widget.hintText!.isNotEmpty
                    ? const EdgeInsets.fromLTRB(
                        12,
                        18.5,
                        12,
                        20,
                      )
                    : const EdgeInsets.fromLTRB(
                        12,
                        20,
                        12,
                        18.5,
                      ),
            errorBorder: _buildOutlineInputBorder(
              borderColor: colorScheme.error,
            ),
            focusedErrorBorder: _buildOutlineInputBorder(
              borderColor: colorScheme.primaryContainer,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }

  Color? fillColor(AppColorScheme colorScheme) {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor;
    }

    if (widget.isDisabled == true) {
      return colorScheme.primaryTonal;
    }

    return Colors.white;
  }

  TextStyle textStyle({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    TextStyle defaultTextStyle = textTheme.bodyLarge.copyWith(
      color: colorScheme.onSurface,
    );

    if (widget.isDisabled == true) {
      defaultTextStyle = defaultTextStyle.copyWith(
        color: colorScheme.onSurfaceBright,
        fontWeight: FontWeight.w600,
      );
    }

    return defaultTextStyle;
  }

  Widget? _buildSuffixIcon(AppColorScheme colorScheme) {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
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

    if (widget.onClear != null && widget.controller?.text.isNotEmpty == true) {
      return GestureDetector(
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
        child: Icon(
          Icons.close,
          color: colorScheme.onSurface,
        ),
      );
    }

    return null;
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
