import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/blood_type_config.dart';
import '../../../../core/config/country_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/sex_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/buttons/radio_widget.dart';
import '../../../../core/ui/widget/dropdowns/dropdown_widget.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/forms/date_form_field_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_form_field_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../activity_level/data/datasources/local/activity_level_local_datasource.dart';
import '../../../activity_level/data/models/activity_level_model.dart';
import '../../../country/data/models/country_model.dart';
import '../cubit/edit_information/edit_information_cubit.dart';

class EditInformationPage extends StatelessWidget {
  const EditInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditInformationCubit>(),
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

  final _membershipIdTextController = TextEditingController();
  final _eKtpTextController = TextEditingController();
  final _fullNameTextController = TextEditingController();
  CountryModel? _selectedCountry;
  final _phoneTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _dateOfBirthTextController = TextEditingController();
  SexType? _selectedSex;
  final _bloodTypeTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  final _heightTextController = TextEditingController();
  ActivityLevelModel? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // init controller
    _membershipIdTextController.text = "111111"; // TODO: get from API

    _eKtpTextController.text = "3506042602660001"; // TODO: get from API

    _fullNameTextController.text = "John Doe"; // TODO: get from API

    _phoneTextController.text = "81234567890"; // TODO: get from API

    _selectedCountry = CountryConfig.indonesia; // TODO: get from API
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
                            TextFormFieldWidget(
                              controller: _membershipIdTextController,
                              title: context.locale.membershipId,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              validator: (val) {
                                return _membershipIdTextController
                                    .validateOnlyNumber(
                                  context: context,
                                  isRequired: true,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _eKtpTextController,
                              title: context.locale.eKtpNumber,
                              keyboardType: TextInputType.number,
                              readOnly:
                                  true, // TODO: if user has eKtp, disable this field
                              validator: (val) {
                                return _eKtpTextController.validateKtp(
                                  context: context,
                                  isRequired:
                                      true, // TODO: if user has eKtp, set to true
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _fullNameTextController,
                              title: context.locale.fullName,
                              validator: (val) {
                                return _fullNameTextController.validateName(
                                  context: context,
                                  isRequired: true,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PhoneNumberFormFieldWidget(
                              controller: _phoneTextController,
                              title: context.locale.phoneNumber,
                              selectedCountry: _selectedCountry,
                              isRequired: true,
                              onSelectedCountry: (val) {
                                if (val != _selectedCountry) {
                                  setState(() {
                                    _selectedCountry = val;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _ageTextController,
                              title: context.locale.age,
                              suffixText: "yo",
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return _ageTextController.validateOnlyNumber(
                                  context: context,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DateFormFieldWidget(
                              controller: _dateOfBirthTextController,
                              title: context.locale.dateOfBirth,
                              hintText: context.locale.choose,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialDate:
                                  _dateOfBirthTextController.text.toDateTime,
                              onSelectedDate: (val) {
                                if (val != null &&
                                    val.toDateApi !=
                                        _dateOfBirthTextController.text) {
                                  setState(() {
                                    _dateOfBirthTextController.text =
                                        val.toDateApi;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: context.width,
                              child: Row(
                                children: SexType.values.map((sexType) {
                                  return RadioWidget(
                                    title: sexType.title(context: context),
                                    value: sexType,
                                    groupValue: _selectedSex,
                                    onChanged: (val) {
                                      if (val != null && val != _selectedSex) {
                                        setState(() {
                                          _selectedSex = val;
                                        });
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
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
                            TextFormFieldWidget(
                              controller: _weightTextController,
                              title: context.locale.weight,
                              suffixText: "kg",
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return _weightTextController.validateOnlyNumber(
                                  context: context,
                                  isAllowComma: true,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _heightTextController,
                              title: context.locale.height,
                              suffixText: "cm",
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                return _heightTextController.validateOnlyNumber(
                                  context: context,
                                  isAllowComma: true,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownWidget<ActivityLevelModel>(
                              itemHeight: 72,
                              items: sl<ActivityLevelLocalDataSource>()
                                  .getActivityLevels()
                                  .map(
                                (activityLevel) {
                                  return DropdownMenuItem(
                                    value: activityLevel,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      height: 72,
                                      child: Row(
                                        children: [
                                          const NetworkImageWidget(
                                            size: Size(40, 40),
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  activityLevel.activity ?? '',
                                                  style: textTheme.labelLarge
                                                      .copyWith(
                                                    color: colorScheme
                                                        .onSurfaceDim,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  activityLevel.description ??
                                                      '',
                                                  style: textTheme.labelMedium
                                                      .copyWith(
                                                    color:
                                                        colorScheme.onSurface,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              title: context.locale.activityLevel,
                              hintText: context.locale.choose,
                              selectedValue: _selectedActivityLevel,
                              onChanged: (option) {
                                if (option != null &&
                                    option != _selectedActivityLevel) {
                                  setState(() {
                                    _selectedActivityLevel = option;
                                  });
                                }
                              },
                              selectedItemBuilder:
                                  sl<ActivityLevelLocalDataSource>()
                                      .getActivityLevels()
                                      .map((e) {
                                return Text(
                                  _selectedActivityLevel?.activity ?? '',
                                  style: textTheme.bodyLarge.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                );
                              }).toList(),
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
                    isLoading: state is EditInformationLoading,
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
      // validate form
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // save to API
      await BlocProvider.of<EditInformationCubit>(context)
          .saveEditInformation();

      // show toast
      context.showToast(
        type: ToastType.success,
        message: context.locale.successEditInformation,
      );

      // TODO: refresh get profile information
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
