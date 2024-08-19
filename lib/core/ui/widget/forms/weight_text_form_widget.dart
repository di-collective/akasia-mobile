import 'package:flutter/material.dart';

import '../../extensions/validation_extension.dart';
import 'text_form_widget.dart';

class WeightTextFormWidget extends TextFormWidget {
  final BuildContext context;

  WeightTextFormWidget({
    super.key,
    required this.context,
    super.controller,
    super.title,
    super.hintText,
    super.isRequired,
    super.onChanged,
    super.onTap,
    super.autofocus,
    super.onEditingComplete,
  }) : super(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          suffixText: "kg",
          validator: (val) {
            return controller?.validateWeight(
              context: context,
              isRequired: isRequired,
              minimum: 1,
            );
          },
        );
}
