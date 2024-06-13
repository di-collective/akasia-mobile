import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/emergency_contact/emergency_contact_cubit.dart';
import '../cubit/profile/profile_cubit.dart';
import '../widgets/profile_detail_item_widget.dart';
import 'edit_allergies_page.dart';
import 'edit_emergency_contact_page.dart';
import 'edit_information_page.dart';

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
    final emergencyContactState =
        BlocProvider.of<EmergencyContactCubit>(context).state;
    if (emergencyContactState is! EmergencyContactLoaded) {
      // if state is not loaded, get data
      _onGetEmergencyContact();
    }
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
            const SizedBox(
              height: 16,
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
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.information,
                      style: textTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceDim,
                      ),
                    ),
                    if (state is ProfileLoaded) ...[
                      GestureDetector(
                        onTap: () {
                          _onEditInformation(state.profile);
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
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String? membershipId;
                  String? nik;
                  String? name;
                  String? phoneNumber;
                  String? age;
                  String? dob;
                  String? sex;
                  String? bloodType;
                  String? weight;
                  String? height;
                  String? activityLevel;
                  if (state is ProfileLoaded) {
                    final profile = state.profile;

                    membershipId = profile.medicalId;
                    nik = profile.nik;
                    name = profile.name;
                    phoneNumber =
                        "${profile.countryCode ?? ''}${profile.phone ?? ''}";
                    if (profile.age != null) {
                      age = '${profile.age} yo';
                    }
                    dob = profile.dob;
                    sex = profile.sex;
                    bloodType = profile.bloodType;
                    if (profile.weight != null) {
                      weight = '${profile.weight} kgs';
                    }
                    if (profile.height != null) {
                      height = '${profile.height} cm';
                    }
                    activityLevel = profile.activityLevel;
                  }

                  return Column(
                    children: [
                      ProfileDetailItemWidget(
                        label: context.locale.membershipId,
                        value: membershipId,
                        isLoading: state is ProfileLoading,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.eKtpNumber,
                        value: nik,
                        isLoading: state is ProfileLoading,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.fullName,
                        value: name,
                        isLoading: state is ProfileLoading,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.phoneNumber,
                        value: phoneNumber,
                        isLoading: state is ProfileLoading,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.age,
                        value: age,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.dob,
                        value: dob,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.sex,
                        value: sex,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.bloodType,
                        value: bloodType,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.weight,
                        value: weight,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.height,
                        value: height,
                      ),
                      Divider(
                        height: 0,
                        color: colorScheme.outlineBright,
                        thickness: 0.5,
                      ),
                      ProfileDetailItemWidget(
                        label: context.locale.activityLevel,
                        value: activityLevel,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
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
                    if (state is ProfileLoaded) ...[
                      GestureDetector(
                        onTap: () {
                          _onEditAllergies(
                            profile: state.profile,
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
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        List<String> allergies = [];
                        final profile = state.profile;
                        if (profile.allergies != null) {
                          allergies = profile.allergies!.split(',');
                        }

                        if (allergies.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              context.locale.empty(context.locale.allergies),
                              maxLines: 5,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium.copyWith(
                                color: colorScheme.onSurfaceDim,
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          runSpacing: 3,
                          spacing: 14,
                          children: allergies.map((allergy) {
                            return Chip(
                              label: Text(
                                allergy.toCapitalizes(),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (state is ProfileError) {
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

  void _onEditInformation(ProfileEntity profile) {
    // go to edit information page
    context.goNamed(
      AppRoute.editInformation.name,
      extra: EditInformationPageParams(
        profile: profile,
      ),
    );
  }

  void _onEditAllergies({
    required ProfileEntity profile,
  }) {
    // go to edit allergies page
    context.goNamed(
      AppRoute.editAllergies.name,
      extra: EditAllergiesPageParams(
        profile: profile,
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
