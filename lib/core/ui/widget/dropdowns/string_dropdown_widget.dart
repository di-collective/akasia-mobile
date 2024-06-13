import 'package:flutter/material.dart';

import '../../extensions/string_extension.dart';
import 'dropdown_widget.dart';

class StringDropdownWidget extends DropdownWidget<String> {
  final List<String> options;

  StringDropdownWidget({
    super.key,
    required this.options,
    super.hintText,
    super.title,
    Function(String? option)? onChanged,
    String? Function(dynamic value)? validator,
    super.selectedValue,
    super.borderRadius,
    super.contentPadding,
    super.isDisabled,
    super.isLoading,
    super.backgroundColor,
    super.isRequired,
    super.borderRadiusMenu,
  }) : super(
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
          validate: validator,
          items: _generateDropdownMenuItem(
            options: options,
          ),
          selectedItemBuilder: _generateItemBuilder(
            options: options,
          ),
        );

  static List<DropdownMenuItem<String>> _generateDropdownMenuItem({
    required List<String> options,
  }) {
    return options.map((level) {
      return DropdownMenuItem<String>(
        value: level,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: Text(
            level.toCapitalize(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }).toList();
  }

  static List<Widget> _generateItemBuilder({
    required List<String> options,
  }) {
    return options.map((level) {
      return Text(
        level.toCapitalize(),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      );
    }).toList();
  }
}
