import 'package:flutter/material.dart';

import '../../extensions/validation_extension.dart';
import 'text_form_widget.dart';

class HeightTextFormWidget extends TextFormWidget {
  final BuildContext context;

  HeightTextFormWidget({
    super.key,
    required this.context,
    super.controller,
    super.title,
    super.hintText,
    super.isRequired,
    super.onChanged,
    super.onTap,
  }) : super(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          suffixText: "cm",
          validator: (val) {
            return controller?.validateHeight(
              context: context,
              isRequired: isRequired,
              minimum: 1,
            );
          },
        );
}
