import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/navigation/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../data/models/allergy_model.dart';
import '../../data/models/emergency_contact_model.dart';
import '../cubit/allergies/allergies_cubit.dart';
import '../cubit/emergency_contact/emergency_contact_cubit.dart';
import '../widgets/profile_detail_item_widget.dart';
import 'edit_allergies_page.dart';
import 'edit_emergency_contact_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    final allergiesState = BlocProvider.of<AllergiesCubit>(context).state;
    if (allergiesState is! AllergiesLoaded) {
      // if state is not loaded, get data
      _onGetAllergies();
    }

    final emergencyContactState =
        BlocProvider.of<EmergencyContactCubit>(context).state;
    if (emergencyContactState is! EmergencyContactLoaded) {
      // if state is not loaded, get data
      _onGetEmergencyContact();
    }
  }

  Future<void> _onGetAllergies() async {
    await BlocProvider.of<AllergiesCubit>(context).getAllergies();
  }

  Future<void> _onGetEmergencyContact() async {
    await BlocProvider.of<EmergencyContactCubit>(context).getEmergencyContact();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.profile),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          children: [
            SizedBox(
              height: context.paddingTop,
            ),
            const NetworkImageWidget(
              size: Size(120, 120),
              shape: BoxShape.circle,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.locale.information,
                  style: textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceDim,
                  ),
                ),
                GestureDetector(
                  onTap: _onEditInformation,
                  child: Text(
                    context.locale.edit,
                    style: textTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.white,
              ),
              child: Column(
                children: [
                  ProfileDetailItemWidget(
                    label: context.locale.membershipId,
                    value: 'MP-12345678',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.eKtpNumber,
                    value: '35743212809076543',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.fullName,
                    value: 'John Doe',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.phoneNumber,
                    value: 'Phone Number',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.age,
                    value: '34 yo',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.dob,
                    value: '11-01-1990',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.sex,
                    value: 'Male',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.bloodType,
                    value: 'B',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.weight,
                    value: '52 kgs',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.height,
                    value: '170 cm',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.activityLevel,
                    value: 'Sedentary',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            BlocBuilder<AllergiesCubit, AllergiesState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.allergies,
                      style: textTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceDim,
                      ),
                    ),
                    if (state is AllergiesLoaded) ...[
                      GestureDetector(
                        onTap: () {
                          _onEditAllergies(
                            allergies: state.allergies,
                          );
                        },
                        child: Text(
                          context.locale.edit,
                          style: textTheme.labelLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: context.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.white,
                  ),
                  child: BlocBuilder<AllergiesCubit, AllergiesState>(
                    builder: (context, state) {
                      if (state is AllergiesLoaded) {
                        final allergies = state.allergies;

                        return Wrap(
                          runSpacing: 3,
                          spacing: 14,
                          children: allergies.map((allergy) {
                            return Chip(
                              label: Text(
                                (allergy.allergy ?? '').toCapitalize(),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (state is AllergiesError) {
                        return Center(
                          child: Text(
                            state.error.message(context),
                            style: textTheme.bodyMedium.copyWith(
                              color: colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return Row(
                        children: List.generate(
                          3,
                          (index) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index == 2 ? 0 : 14,
                                ),
                                child: ShimmerLoading.circular(
                                  width: context.width,
                                  height: 32,
                                  shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            BlocBuilder<EmergencyContactCubit, EmergencyContactState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.emergencyContact,
                      style: textTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceDim,
                      ),
                    ),
                    if (state is EmergencyContactLoaded) ...[
                      GestureDetector(
                        onTap: () {
                          _onEmergencyContact(
                            emergencyContact: state.emergencyContact,
                          );
                        },
                        child: Text(
                          context.locale.edit,
                          style: textTheme.labelLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.white,
              ),
              child: BlocBuilder<EmergencyContactCubit, EmergencyContactState>(
                builder: (context, state) {
                  if (state is EmergencyContactLoaded) {
                    return Column(
                      children: [
                        ProfileDetailItemWidget(
                          label: context.locale.relationship,
                          value: state.emergencyContact.relationship,
                        ),
                        Divider(
                          height: 0,
                          color: colorScheme.outlineBright,
                          thickness: 0.5,
                        ),
                        ProfileDetailItemWidget(
                          label: context.locale.fullName,
                          value: state.emergencyContact.name,
                        ),
                        Divider(
                          height: 0,
                          color: colorScheme.outlineBright,
                          thickness: 0.5,
                        ),
                        ProfileDetailItemWidget(
                          label: context.locale.phoneNumber,
                          value:
                              '${state.emergencyContact.countryCode}${state.emergencyContact.phoneNumber}',
                        ),
                      ],
                    );
                  } else if (state is EmergencyContactError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          state.error.message(context),
                          style: textTheme.bodyMedium.copyWith(
                            color: colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : 8,
                            ),
                            child: ShimmerLoading.circular(
                              width: context.width,
                              height: 32,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onEditInformation() {
    // go to edit information page
    context.goNamed(AppRoute.editInformation.name);
  }

  void _onEditAllergies({
    required List<AllergyModel> allergies,
  }) {
    // go to edit allergies page
    context.goNamed(
      AppRoute.editAllergies.name,
      extra: EditAllergiesPageParams(
        allergies: allergies,
      ),
    );
  }

  void _onEmergencyContact({
    required EmergencyContactModel emergencyContact,
  }) {
    // go to edit emergency contact page
    context.goNamed(
      AppRoute.editEmergencyContact.name,
      extra: EditEmergencyContactPageParams(
        emergencyContact: emergencyContact,
      ),
    );
  }
}
