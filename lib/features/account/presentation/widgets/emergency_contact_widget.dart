import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile/profile_cubit.dart';
import '../pages/edit_emergency_contact_page.dart';
import 'profile_detail_item_widget.dart';

class EmergencyContactWidget extends StatefulWidget {
  const EmergencyContactWidget({super.key});

  @override
  State<EmergencyContactWidget> createState() => _EmergencyContactWidgetState();
}

class _EmergencyContactWidgetState extends State<EmergencyContactWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
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
                if (state is ProfileLoaded) ...[
                  GestureDetector(
                    onTap: () {
                      _onEmergencyContact(
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.white,
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                String? phoneNumber;
                if (state.profile.ecCountryCode != null) {
                  phoneNumber = state.profile.ecCountryCode;
                }
                if (state.profile.ecPhone != null) {
                  phoneNumber = "$phoneNumber${state.profile.ecPhone}";
                }

                return Column(
                  children: [
                    ProfileDetailItemWidget(
                      label: context.locale.relationship,
                      value: state.profile.ecRelation,
                    ),
                    Divider(
                      height: 0,
                      color: colorScheme.outlineBright,
                      thickness: 0.5,
                    ),
                    ProfileDetailItemWidget(
                      label: context.locale.fullName,
                      value: state.profile.ecName,
                    ),
                    Divider(
                      height: 0,
                      color: colorScheme.outlineBright,
                      thickness: 0.5,
                    ),
                    ProfileDetailItemWidget(
                      label: context.locale.phoneNumber,
                      value: phoneNumber,
                    ),
                  ],
                );
              } else if (state is ProfileError) {
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
      ],
    );
  }

  void _onEmergencyContact({
    required ProfileEntity profile,
  }) {
    // go to edit emergency contact page
    context.goNamed(
      AppRoute.editEmergencyContact.name,
      extra: EditEmergencyContactPageParams(
        profile: profile,
      ),
    );
  }
}
