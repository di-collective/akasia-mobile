import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/country/domain/entities/country_entity.dart';
import '../../extensions/validation_extension.dart';
import 'text_form_widget.dart';

class PhoneNumberTextFormWidget extends TextFormWidget {
  final BuildContext context;
  final CountryEntity? selectedCountry;
  final bool? isCannotSameAs;
  final String? anotherPhoneNumber;

  PhoneNumberTextFormWidget({
    super.key,
    required this.context,
    required this.selectedCountry,
    this.isCannotSameAs,
    this.anotherPhoneNumber,
    super.controller,
    super.title,
    super.hintText,
    super.isRequired,
    super.isLoading,
    super.onChanged,
    super.onTap,
  }) : super(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: false,
          ),
          prefixText: selectedCountry?.phoneCode != null
              ? "+${selectedCountry?.phoneCode}"
              : null,
          validator: (val) {
            return controller?.validatePhoneNumber(
              context: context,
              isRequired: isRequired,
              isCannotSameAs: isCannotSameAs,
              anotherPhoneNumber: anotherPhoneNumber,
            );
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        );
}
