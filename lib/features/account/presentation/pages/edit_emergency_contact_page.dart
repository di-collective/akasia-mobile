import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/relationship_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_form_field_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/data/models/country_model.dart';
import '../../../country/presentation/cubit/countries/countries_cubit.dart';
import '../../data/models/emergency_contact_model.dart';
import '../cubit/edit_emergency_contact/edit_emergency_contact_cubit.dart';

class EditEmergencyContactPageParams {
  final EmergencyContactModel? emergencyContact;

  const EditEmergencyContactPageParams({
    required this.emergencyContact,
  });
}

class EditEmergencyContactPage<T> extends StatelessWidget {
  final T? params;

  const EditEmergencyContactPage({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EditEmergencyContactCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CountriesCubit>(),
        ),
      ],
      child: _Body(
        params: params,
      ),
    );
  }
}

class _Body<T> extends StatefulWidget {
  final T? params;

  const _Body({
    this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();

  final _relationshipTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();

  CountryModel? _selectedCountry;
  EmergencyContactModel? _activeEmergencyContact;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final params = widget.params;
    if (params is EditEmergencyContactPageParams) {
      // Set the initial values
      _activeEmergencyContact = params.emergencyContact;

      _relationshipTextController.text =
          _activeEmergencyContact?.relationship ?? '';
      _nameTextController.text = _activeEmergencyContact?.name ?? '';
      _phoneNumberTextController.text =
          _activeEmergencyContact?.phoneNumber ?? '';

      // init country
      _initCountry();
    }
  }

  Future<void> _initCountry() async {
    final countries =
        await BlocProvider.of<CountriesCubit>(context).getCountries();
    if (countries.isNotEmpty) {
      final result = countries.firstWhereOrNull((country) {
        return country.phoneCode == _activeEmergencyContact?.countryCode;
      });

      // Set country
      if (result != null) {
        setState(() {
          _selectedCountry = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<EditEmergencyContactCubit, EditEmergencyContactState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.locale.emergencyContact),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              context.locale.emergencyContact,
                              style: textTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurfaceDim,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            StringDropdownWidget(
                              title: context.locale.relationship,
                              hintText: context.locale.choose,
                              options: RelationshipConfig.allRelationships,
                              isRequired: true,
                              selectedValue:
                                  _relationshipTextController.text.isEmpty
                                      ? null
                                      : _relationshipTextController.text,
                              onChanged: (option) {
                                if (option != null &&
                                    option !=
                                        _relationshipTextController.text) {
                                  setState(() {
                                    _relationshipTextController.text = option;
                                  });
                                }
                              },
                              validator: (value) {
                                return _relationshipTextController.cannotEmpty(
                                  context: context,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _nameTextController,
                              title: context.locale.fullName,
                              isRequired: true,
                              validator: (val) {
                                return _nameTextController.validateName(
                                  context: context,
                                  isRequired: true,
                                );
                              },
                              onChanged: (val) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<CountriesCubit, CountriesState>(
                              builder: (context, state) {
                                return PhoneNumberFormFieldWidget(
                                  controller: _phoneNumberTextController,
                                  title: context.locale.phoneNumber,
                                  selectedCountry: _selectedCountry,
                                  isRequired: true,
                                  isLoading: state is CountriesLoading,
                                  onSelectedCountry: (val) {
                                    if (val != _selectedCountry) {
                                      setState(() {
                                        _selectedCountry = val;
                                      });
                                    }
                                  },
                                  onChanged: (val) {
                                    // reload
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
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
                    isLoading: state is EditEmergencyContactLoading,
                    isDisabled: _relationshipTextController.text ==
                            _activeEmergencyContact?.relationship &&
                        _nameTextController.text ==
                            _activeEmergencyContact?.name &&
                        _phoneNumberTextController.text ==
                            _activeEmergencyContact?.phoneNumber,
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
    } catch (error) {
      context.showToast(
        message: error.message(context),
        type: ToastType.error,
      );
    }
  }
}
