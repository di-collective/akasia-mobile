import 'package:flutter/material.dart';

import '../../../../features/country/data/models/country_model.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/validation_extension.dart';
import 'text_form_field_widget.dart';

class PhoneNumberFormFieldWidget extends StatefulWidget {
  final TextEditingController textController;
  final CountryModel? selectedCountry;
  final Function(CountryModel) onSelectedCountry;
  final bool? isRequired, isLoading;
  final Function(String)? onChanged;

  const PhoneNumberFormFieldWidget({
    super.key,
    required this.textController,
    this.selectedCountry,
    required this.onSelectedCountry,
    this.isRequired,
    this.isLoading,
    this.onChanged,
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
      controller: widget.textController,
      title: context.locale.phoneNumber,
      keyboardType: TextInputType.phone,
      isRequired: widget.isRequired,
      isLoading: widget.isLoading,
      onChanged: widget.onChanged,
      validator: (val) {
        return widget.textController.validatePhoneNumber(
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
