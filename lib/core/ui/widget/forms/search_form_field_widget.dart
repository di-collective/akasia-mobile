import 'package:flutter/material.dart';

import '../dialogs/debouncer_info.dart';
import 'text_form_field_widget.dart';

class SearchFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title, hintText;
  final Function()? onClear;
  final Function(String? query)? onChanged;
  final bool? isDisableDebouncer;

  const SearchFormFieldWidget({
    super.key,
    this.controller,
    this.title,
    this.hintText,
    this.onClear,
    this.onChanged,
    this.isDisableDebouncer,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      controller: controller,
      title: title,
      hintText: hintText,
      onClear: onClear,
      onChanged: (value) {
        if (onChanged == null) {
          return;
        }

        if (isDisableDebouncer == true) {
          onChanged!(value);

          return;
        }

        // debounce for 0.8 seconds
        final debouncer = DebouncerInfo(milliseconds: 800);

        debouncer.run(() {
          if (value == controller?.text) {
            // do handle change when bouncer value same with text controller
            onChanged!(value);
          }
        });
      },
    );
  }
}
