import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/validation_extension.dart';
import 'text_form_field_widget.dart';

class KtpTextFormWidget extends TextFormFieldWidget {
  final BuildContext context;

  KtpTextFormWidget({
    super.key,
    required this.context,
    super.controller,
    super.title,
    super.hintText,
    super.isRequired,
    super.isLoading,
    super.readOnly,
    super.onChanged,
    super.onTap,
  }) : super(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: false,
          ),
          validator: (val) {
            return controller?.validateKtp(
              context: context,
              isRequired: isRequired,
            );
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        );
}
