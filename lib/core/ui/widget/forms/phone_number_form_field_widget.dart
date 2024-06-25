import 'package:flutter/material.dart';

import '../../../../features/country/domain/entities/country_entity.dart';
import '../../extensions/validation_extension.dart';
import 'text_form_field_widget.dart';

class PhoneNumberFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final CountryEntity? selectedCountry;
  final Function(CountryEntity)? onSelectedCountry;
  final bool? isRequired, isLoading;
  final Function(String)? onChanged;
  final Function(String?)? validator;

  const PhoneNumberFormFieldWidget({
    super.key,
    required this.controller,
    this.title,
    this.selectedCountry,
    this.onSelectedCountry,
    this.isRequired,
    this.isLoading,
    this.onChanged,
    this.validator,
  });

  @override
  State<PhoneNumberFormFieldWidget> createState() =>
      _PhoneNumberFormFieldWidgetState();
}

class _PhoneNumberFormFieldWidgetState
    extends State<PhoneNumberFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      controller: widget.controller,
      title: widget.title,
      keyboardType: TextInputType.phone,
      isRequired: widget.isRequired,
      isLoading: widget.isLoading,
      onChanged: widget.onChanged,
      validator: (val) {
        if (widget.validator != null) {
          return widget.validator!(val);
        }

        return widget.controller.validatePhoneNumber(
          context: context,
          isRequired: widget.isRequired,
        );
      },
      prefixText: widget.selectedCountry?.phoneCode,
      // onTapPrefixText: _onSelectCountry,
    );
  }

  // Future<void> _onSelectCountry() async {
  //   return await context.showDialog(
  //     child: SizedBox(
  //       height: context.height * 0.9,
  //       child: SearchCountriesWidget(
  //         selectedCountry: widget.selectedCountry,
  //       ),
  //     ),
  //   );
  // }
}
