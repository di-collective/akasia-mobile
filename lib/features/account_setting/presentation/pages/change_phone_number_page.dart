import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/country_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_text_form_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/domain/entities/country_entity.dart';
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

  CountryEntity? _selectedCountry;

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
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<ChangePhoneNumberCubit, ChangePhoneNumberState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.changePhoneNumber.toCapitalizes(),
                style: TextStyle(
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              backgroundColor: colorScheme.white,
              iconTheme: IconThemeData(
                color: colorScheme.primary,
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
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            PhoneNumberTextFormWidget(
                              context: context,
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
                            PhoneNumberTextFormWidget(
                              context: context,
                              controller: _newPhoneNumberTextController,
                              title: context.locale.newPhoneNumber,
                              isRequired: true,
                              selectedCountry: _selectedCountry,
                              onChanged: (_) {
                                // reload
                                setState(() {});
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

      final oldPhoneNumber = _oldPhoneNumberTextController.text;
      final newPhoneNumber = _newPhoneNumberTextController.text;

      // validate if same
      if (oldPhoneNumber.isSame(otherValue: newPhoneNumber)) {
        throw context.locale.phoneNumberCannotSame;
      }

      // call change phone number
      await BlocProvider.of<ChangePhoneNumberCubit>(context).changePassword(
        oldPhoneNumber: oldPhoneNumber,
        newPhoneNumber: newPhoneNumber,
      );

      // show success message
      context.showSuccessToast(
        message: context.locale.successChangePhoneNumber,
      );

      // close page
      Navigator.pop(context);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
