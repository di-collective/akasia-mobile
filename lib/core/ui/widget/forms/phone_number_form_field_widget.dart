import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/validation_extension.dart';
import 'text_form_field_widget.dart';

class PhoneNumberFormFieldWidget extends StatelessWidget {
  final TextEditingController textController;
  final Country? selectedCountry;
  final Function(Country) onSelectedCountry;
  final bool? isRequired;

  const PhoneNumberFormFieldWidget({
    super.key,
    required this.textController,
    this.selectedCountry,
    required this.onSelectedCountry,
    this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      controller: textController,
      title: context.locale.phoneNumber,
      keyboardType: TextInputType.phone,
      isRequired: isRequired,
      validator: (val) {
        return textController.validatePhoneNumber(
          context: context,
          isRequired: isRequired,
        );
      },
      prefixText: selectedCountry?.phoneCode,
      onTapPrefixText: () {
        context.selectCountryCode(
          onSelect: onSelectedCountry,
        );
      },
    );
  }
}
