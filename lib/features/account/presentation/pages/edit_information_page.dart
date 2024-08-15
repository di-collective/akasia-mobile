import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/country_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/sex_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/forms/date_form_widget.dart';
import '../../../../core/ui/widget/forms/height_text_form_widget.dart';
import '../../../../core/ui/widget/forms/ktp_text_form_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_text_form_widget.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import '../../../../core/ui/widget/radios/gender_radio_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/domain/entities/country_entity.dart';
import '../../data/datasources/local/blood_type_config.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/edit_information/edit_information_cubit.dart';
import '../cubit/profile/profile_cubit.dart';

class EditInformationPageParams {
  final ProfileEntity profile;

  EditInformationPageParams({
    required this.profile,
  });
}

class EditInformationPage extends StatelessWidget {
  final EditInformationPageParams? params;

  const EditInformationPage({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditInformationCubit>(),
      child: _Body(
        params: params,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final EditInformationPageParams? params;

  const _Body({
    this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();

  final _membershipIdTextController = TextEditingController();
  final _eKtpTextController = TextEditingController();
  final _fullNameTextController = TextEditingController();
  CountryEntity? _selectedCountry;
  final _phoneTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _dateOfBirthTextController = TextEditingController();
  DateTime? _selectedDateOfBirth;
  SexType? _selectedSex;
  final _bloodTypeTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  final _heightTextController = TextEditingController();
  // ActivityLevelEntity? _selectedActivityLevel;

  ProfileEntity? _activeProfile;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedCountry = CountryConfig.indonesia; // TODO: Dynamic country

    final params = widget.params;
    if (params != null) {
      _activeProfile = params.profile;

      // init controller
      _membershipIdTextController.text = _activeProfile?.medicalId ?? '';
      _eKtpTextController.text = _activeProfile?.nik ?? '';
      _fullNameTextController.text = _activeProfile?.name ?? '';
      _phoneTextController.text = _activeProfile?.phone ?? '';
      _ageTextController.text = _activeProfile?.age ?? '';
      if (_activeProfile?.dob != null) {
        _selectedDateOfBirth = _activeProfile?.dob?.toDateTime();
        _dateOfBirthTextController.text =
            _selectedDateOfBirth?.formatDate() ?? '';
      }
      _selectedSex = SexTypeExtension.fromString(_activeProfile?.sex);
      _bloodTypeTextController.text = _activeProfile?.bloodType ?? '';
      _weightTextController.text = _activeProfile?.weight?.toString() ?? '';
      _heightTextController.text = _activeProfile?.height?.toString() ?? '';
      // _selectedActivityLevel =
      //     ActivityLevelLocalConfig.allActivityLevels.firstWhereOrNull(
      //   (element) => (element.activity ?? '').isSame(
      //     otherValue: _activeProfile?.activityLevel,
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _membershipIdTextController.dispose();
    _eKtpTextController.dispose();
    _fullNameTextController.dispose();
    _phoneTextController.dispose();
    _ageTextController.dispose();
    _dateOfBirthTextController.dispose();
    _bloodTypeTextController.dispose();
    _weightTextController.dispose();
    _heightTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<EditInformationCubit, EditInformationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.locale.information),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              context.locale.personalInformation,
                              style: textTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurfaceDim,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormWidget(
                              controller: _membershipIdTextController,
                              title: context.locale.membershipId,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              isRequired: true,
                              validator: (val) {
                                return _membershipIdTextController.cannotEmpty(
                                  context: context,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            KtpTextFormWidget(
                              context: context,
                              controller: _eKtpTextController,
                              title: context.locale.eKtpNumber,
                              readOnly: _activeProfile?.nik !=
                                  null, // if user has eKtp, set to true
                              isRequired: _activeProfile?.nik !=
                                  null, // if user has eKtp, set to true
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormWidget(
                              controller: _fullNameTextController,
                              title: context.locale.fullName,
                              isRequired: true,
                              readOnly: true,
                              validator: (val) {
                                return _fullNameTextController.validateName(
                                  context: context,
                                  isRequired: true,
                                );
                              },
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
                              controller: _phoneTextController,
                              title: context.locale.phoneNumber,
                              selectedCountry: _selectedCountry,
                              isRequired: true,
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormWidget(
                              controller: _ageTextController,
                              title: context.locale.age,
                              suffixText: "yo",
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return _ageTextController.validateOnlyNumber(
                                  context: context,
                                );
                              },
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DateFormWidget(
                              controller: _dateOfBirthTextController,
                              title: context.locale.dateOfBirth,
                              hintText: context.locale.choose,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialDate: _selectedDateOfBirth,
                              onSelectedDate: (val) {
                                if (val == null) {
                                  return;
                                }
                                if (val == _selectedDateOfBirth) {
                                  return;
                                }

                                final newDate = val.formatDate();
                                if (newDate == null) {
                                  return;
                                }

                                setState(() {
                                  _dateOfBirthTextController.text = newDate;
                                  _selectedDateOfBirth = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GenderRadioWidget(
                              groupValue: _selectedSex,
                              title: context.locale.gender,
                              onChanged: (val) {
                                if (val != null && val != _selectedSex) {
                                  setState(() {
                                    _selectedSex = val;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StringDropdownWidget(
                              title: context.locale.bloodType,
                              hintText: context.locale.choose,
                              options: BloodTypeConfig.allBloodTypes,
                              selectedValue:
                                  _bloodTypeTextController.text.isEmpty
                                      ? null
                                      : _bloodTypeTextController.text,
                              onChanged: (option) {
                                if (option != null &&
                                    option != _bloodTypeTextController.text) {
                                  setState(() {
                                    _bloodTypeTextController.text = option;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            WeightTextFormWidget(
                              context: context,
                              controller: _weightTextController,
                              title: context.locale.weight,
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            HeightTextFormWidget(
                              context: context,
                              controller: _heightTextController,
                              title: context.locale.height,
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // ActivityLevelDropdownWidget(
                            //   context: context,
                            //   title: context.locale.activityLevel,
                            //   hintText: context.locale.choose,
                            //   selectedValue: _selectedActivityLevel,
                            //   onChanged: (option) {
                            //     if (option != null &&
                            //         option != _selectedActivityLevel) {
                            //       setState(() {
                            //         _selectedActivityLevel = option;
                            //       });
                            //     }
                            //   },
                            // ),
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
                    isLoading: state is EditInformationLoading,
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

    // validate by active profile
    return _validateByActiveProfile;
  }

  bool get _validateByActiveProfile {
    if (!(_activeProfile?.nik ?? '')
        .isSame(otherValue: _eKtpTextController.text)) {
      return false;
    }

    if (!(_activeProfile?.countryCode ?? '')
        .isSame(otherValue: _selectedCountry?.phoneCode ?? '')) {
      return false;
    }

    if (!(_activeProfile?.phone ?? '')
        .isSame(otherValue: _phoneTextController.text)) {
      return false;
    }

    if (!(_activeProfile?.age ?? '')
        .isSame(otherValue: _ageTextController.text)) {
      return false;
    }

    if (!(_activeProfile?.dob?.formatDate() ?? '')
        .isSame(otherValue: _dateOfBirthTextController.text)) {
      return false;
    }

    if (!(_selectedSex?.name ?? '')
        .isSame(otherValue: _activeProfile?.sex ?? '')) {
      return false;
    }

    if (!(_activeProfile?.bloodType ?? '')
        .isSame(otherValue: _bloodTypeTextController.text)) {
      return false;
    }

    if (!(_activeProfile?.weight
            ?.isSame(otherValue: _weightTextController.text.parseToDouble) ??
        true)) {
      return false;
    }

    if (!(_activeProfile?.height
            ?.isSame(otherValue: _heightTextController.text.parseToDouble) ??
        true)) {
      return false;
    }

    // if (!(_selectedActivityLevel?.activity ?? '')
    //     .isSame(otherValue: _activeProfile?.activityLevel ?? '')) {
    //   return false;
    // }

    return true;
  }

  Future<void> _onSave() async {
    try {
      // validate form
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      ProfileEntity profile = ProfileEntity(
        userId: _activeProfile?.userId,
      );

      // nik
      if (!(_activeProfile?.nik ?? '')
          .isSame(otherValue: _eKtpTextController.text)) {
        profile = profile.copyWith(
          nik: _eKtpTextController.text,
        );
      }

      // country code
      if (!(_activeProfile?.countryCode ?? '')
          .isSame(otherValue: _selectedCountry?.phoneCode ?? '')) {
        profile = profile.copyWith(
          countryCode: _selectedCountry?.phoneCode ?? '',
        );
      }

      // phone number
      if (!(_activeProfile?.phone ?? '')
          .isSame(otherValue: _phoneTextController.text)) {
        profile = profile.copyWith(
          phone: _phoneTextController.text,
        );
      }

      // age
      if (!(_activeProfile?.age ?? '')
          .isSame(otherValue: _ageTextController.text)) {
        profile = profile.copyWith(
          age: _ageTextController.text,
        );
      }

      // date of birth
      if (!(_activeProfile?.dob?.formatDate() ?? '')
          .isSame(otherValue: _dateOfBirthTextController.text)) {
        profile = profile.copyWith(
          dob: _selectedDateOfBirth?.toDateApi,
        );
      }

      // sex
      if (!(_selectedSex?.name ?? '').isSame(otherValue: _activeProfile?.sex)) {
        profile = profile.copyWith(
          sex: _selectedSex?.name.toCapitalize(),
        );
      }

      // blood type
      if (!(_activeProfile?.bloodType ?? '')
          .isSame(otherValue: _bloodTypeTextController.text)) {
        profile = profile.copyWith(
          bloodType: _bloodTypeTextController.text,
        );
      }

      // weight
      if (!(_activeProfile?.weight
              ?.isSame(otherValue: _weightTextController.text.parseToDouble) ??
          true)) {
        profile = profile.copyWith(
          weight: _weightTextController.text.parseToDouble,
        );
      }

      // height
      if (!(_activeProfile?.height
              ?.isSame(otherValue: _heightTextController.text.parseToDouble) ??
          true)) {
        profile = profile.copyWith(
          height: _heightTextController.text.parseToDouble,
        );
      }

      // // activity level
      // if (!(_activeProfile?.activityLevel ?? '')
      //     .isSame(otherValue: _selectedActivityLevel?.activity ?? '')) {
      //   profile = profile.copyWith(
      //     activityLevel: _selectedActivityLevel?.activity ?? '',
      //   );
      // }

      // save to API
      await BlocProvider.of<EditInformationCubit>(context).saveEditInformation(
        profile: profile,
      );

      // show toast
      context.showSuccessToast(
        message: context.locale.successEditInformation,
      );

      // update active profile
      setState(() {
        _activeProfile = _activeProfile?.copyWith(
          nik: profile.nik,
          name: profile.name,
          countryCode: profile.countryCode,
          phone: profile.phone,
          age: profile.age,
          dob: profile.dob,
          sex: profile.sex,
          bloodType: profile.bloodType,
          weight: profile.weight,
          height: profile.height,
          activityLevel: profile.activityLevel,
        );
      });

      // update profile state
      if (_activeProfile != null) {
        BlocProvider.of<ProfileCubit>(context).emitProfileData(
          _activeProfile!,
        );
      }
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
