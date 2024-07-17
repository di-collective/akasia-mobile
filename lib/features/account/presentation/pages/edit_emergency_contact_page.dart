import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/country_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_text_form_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/domain/entities/country_entity.dart';
import '../../../country/presentation/cubit/countries/countries_cubit.dart';
import '../../data/datasources/local/relationship_config.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/edit_emergency_contact/edit_emergency_contact_cubit.dart';
import '../cubit/profile/profile_cubit.dart';

class EditEmergencyContactPageParams {
  final ProfileEntity? profile;

  const EditEmergencyContactPageParams({
    required this.profile,
  });
}

class EditEmergencyContactPage extends StatelessWidget {
  final EditEmergencyContactPageParams? params;

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

class _Body extends StatefulWidget {
  final EditEmergencyContactPageParams? params;

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
  final _phoneTextController = TextEditingController();
  CountryEntity? _selectedCountry;

  String? _activeEcRelation;
  String? _activeEcName;
  String? _activeEcPhone;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final params = widget.params;
    if (params != null) {
      // Set the initial values
      _activeEcRelation = params.profile?.ecRelation;
      _activeEcName = params.profile?.ecName;
      _selectedCountry = CountryConfig.indonesia; // TODO: Dynamic country
      _activeEcPhone = params.profile?.ecPhone;

      if (_activeEcRelation != null) {
        final relation = RelationshipConfig.allRelationships.firstWhereOrNull(
          (element) {
            return element.isSame(
              otherValue: _activeEcRelation,
            );
          },
        );
        if (relation != null) {
          _relationshipTextController.text = relation;
        }
      }

      _nameTextController.text = _activeEcName ?? '';
      _phoneTextController.text = _activeEcPhone ?? '';
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
                              borderRadiusMenu: BorderRadius.circular(8),
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
                                return PhoneNumberTextFormWidget(
                                  context: context,
                                  controller: _phoneTextController,
                                  title: context.locale.phoneNumber,
                                  selectedCountry: _selectedCountry,
                                  isRequired: true,
                                  isLoading: state is CountriesLoading,
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
                    isDisabled: _isDisabled,
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

  bool get _isDisabled {
    // validate form
    if (_formKey.currentState?.validate() != true) {
      return true;
    }

    // validate by active emergency contact
    return _validateByActiveEmergencyContact;
  }

  bool get _validateByActiveEmergencyContact {
    // relation
    if (!(_activeEcRelation ?? '')
        .isSame(otherValue: _relationshipTextController.text)) {
      return false;
    }

    // name
    if (!(_activeEcName ?? '').isSame(otherValue: _nameTextController.text)) {
      return false;
    }

    // phone
    if (!(_activeEcPhone ?? '').isSame(otherValue: _phoneTextController.text)) {
      return false;
    }

    return true;
  }

  Future<void> _onSave() async {
    try {
      ProfileEntity? newProfile;
      if (widget.params is EditEmergencyContactPageParams) {
        newProfile = (widget.params as EditEmergencyContactPageParams).profile;
      }
      if (newProfile == null) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // relation
      String? newEcRelation;
      if (!(_activeEcRelation ?? '')
          .isSame(otherValue: _relationshipTextController.text)) {
        newEcRelation = _relationshipTextController.text;
        newProfile = newProfile.copyWith(
          ecRelation: newEcRelation,
        );
      }

      // name
      String? newEcName;
      if (!(_activeEcName ?? '').isSame(otherValue: _nameTextController.text)) {
        newEcName = _nameTextController.text;
        newProfile = newProfile.copyWith(
          ecName: newEcName,
        );
      }

      // phone
      String? newEcPhone;
      if (!(_activeEcPhone ?? '')
          .isSame(otherValue: _phoneTextController.text)) {
        newEcPhone = _phoneTextController.text;
        newProfile = newProfile.copyWith(
          ecPhone: newEcPhone,
        );
      }

      // edit emergency contact
      await BlocProvider.of<EditEmergencyContactCubit>(context)
          .editEmergencyContact(
        userId: newProfile.userId,
        ecRelation: newEcRelation,
        ecName: newEcName,
        ecCountryCode: null, // TODO: Dynamic country
        ecPhone: newEcPhone,
      );

      // sho success message
      context.showSuccessToast(
        message: context.locale.successEditEmergencyContact,
      );

      // update active emergency contact
      setState(() {
        _activeEcRelation = newProfile?.ecRelation;
        _activeEcName = _nameTextController.text;
        _activeEcPhone = _phoneTextController.text;
      });

      // update emergency contact state
      BlocProvider.of<ProfileCubit>(context).emitProfileData(
        newProfile.copyWith(
          ecRelation: _activeEcRelation,
          ecName: _activeEcName,
          ecPhone: _activeEcPhone,
        ),
      );
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
