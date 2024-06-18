import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile/profile_cubit.dart';
import '../pages/edit_allergies_page.dart';

class AllergiesWidget extends StatefulWidget {
  const AllergiesWidget({super.key});

  @override
  State<AllergiesWidget> createState() => _AllergiesWidgetState();
}

class _AllergiesWidgetState extends State<AllergiesWidget> {
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
                    return Padding(
                      padding: const EdgeInsets.all(16),
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
      ],
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
}
