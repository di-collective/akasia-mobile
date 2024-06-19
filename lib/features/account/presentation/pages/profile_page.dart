import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile/profile_cubit.dart';
import '../widgets/allergies_widget.dart';
import '../widgets/emergency_contact_widget.dart';
import '../widgets/profile_detail_item_widget.dart';
import 'edit_information_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                String? photoUrl;
                if (state is ProfileLoaded) {
                  photoUrl = state.profile.photoUrl;
                }

                return NetworkImageWidget(
                  size: const Size(120, 120),
                  shapeBorder: const CircleBorder(),
                  fit: BoxFit.cover,
                  imageUrl: photoUrl,
                  isLoading: state is ProfileLoading,
                );
              },
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
                    if (state.profile.countryCode != null) {
                      phoneNumber = state.profile.countryCode;
                    }
                    if (state.profile.phone != null) {
                      phoneNumber = "$phoneNumber${state.profile.phone}";
                    }
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
                        value: dob?.formatDate(),
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
            const AllergiesWidget(),
            const SizedBox(
              height: 40,
            ),
            const EmergencyContactWidget(),
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
}
