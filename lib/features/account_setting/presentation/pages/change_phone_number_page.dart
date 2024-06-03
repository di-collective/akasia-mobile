import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/country_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/data/models/country_model.dart';
import '../cubit/change_phone_number/change_phone_number_cubit.dart';

class ChangePhoneNumberPage extends StatelessWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePhoneNumberCubit>(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();

  final _oldPhoneNumberTextController = TextEditingController();
  final _newPhoneNumberTextController = TextEditingController();

  CountryModel? _selectedCountry;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedCountry = CountryConfig.indonesia;
  }

  @override
  void dispose() {
    super.dispose();

    _oldPhoneNumberTextController.dispose();
    _newPhoneNumberTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<ChangePhoneNumberCubit, ChangePhoneNumberState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.changePhoneNumber.toCapitalizes(),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            PhoneNumberFormFieldWidget(
                              controller: _oldPhoneNumberTextController,
                              title: context.locale.oldPhoneNumber,
                              isRequired: true,
                              selectedCountry: _selectedCountry,
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PhoneNumberFormFieldWidget(
                              controller: _newPhoneNumberTextController,
                              title: context.locale.newPhoneNumber,
                              isRequired: true,
                              selectedCountry: _selectedCountry,
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                              validator: (val) {
                                return _newPhoneNumberTextController
                                    .validatePhoneNumber(
                                  context: context,
                                  isRequired: true,
                                  isCannotSameAs: true,
                                  anotherPhoneNumber:
                                      _oldPhoneNumberTextController.text,
                                );
                              },
                            ),
                            SizedBox(
                              height: context.paddingBottom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    text: context.locale.save,
                    width: context.width,
                    isLoading: state is ChangePhoneNumberLoading,
                    isDisabled: _oldPhoneNumberTextController.text.isEmpty ||
                        _formKey.currentState?.validate() == false,
                    onTap: _onSave,
                  ),
                  SizedBox(
                    height: context.paddingBottom,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSave() async {
    try {
      // validate
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // call change phone number
      await BlocProvider.of<ChangePhoneNumberCubit>(context).changePassword(
        oldPhoneNumber: _oldPhoneNumberTextController.text,
        newPhoneNumber: _newPhoneNumberTextController.text,
      );

      // show success message
      context.showToast(
        message: context.locale.successChangePhoneNumber,
        type: ToastType.success,
      );

      // close page
      Navigator.pop(context);
    } catch (error) {
      context.showToast(
        message: error.message(context),
        type: ToastType.error,
      );
    }
  }
}
