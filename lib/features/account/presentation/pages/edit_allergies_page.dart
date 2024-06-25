import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dropdowns/dropdown_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/datasources/local/allergy_config.dart';
import '../../domain/entities/allergy_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/edit_allergies/edit_allergies_cubit.dart';
import '../cubit/profile/profile_cubit.dart';

class EditAllergiesPageParams {
  final ProfileEntity? profile;

  EditAllergiesPageParams({
    required this.profile,
  });
}

class EditAllergiesPage extends StatelessWidget {
  final EditAllergiesPageParams? params;

  const EditAllergiesPage({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EditAllergiesCubit>(),
        ),
      ],
      child: _Body(
        params: params,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final EditAllergiesPageParams? params;

  const _Body({
    this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  List<String> activeMyAllergies = [];
  List<String> newMyAllergies = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // init default allergies
    final params = widget.params;
    if (params != null) {
      final paramsAllergies = params.profile?.allergies;
      if (paramsAllergies != null) {
        final allergies = paramsAllergies.split(',').map((allergy) {
          return allergy;
        }).toList();

        activeMyAllergies = List.from(allergies);
        newMyAllergies = List.from(allergies);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.locale.allergies),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "${context.locale.youHaveAnyAllergies}?",
                        style: textTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      DropdownWidget<AllergyEntity>(
                        selectedValue: null,
                        hintText: context.locale.choose,
                        items: AllergyConfig.allAllergies.map((allergy) {
                          final allergyName = allergy.allergy;

                          final isSelected = newMyAllergies.any(
                            (element) => element.isSame(
                              otherValue: allergyName,
                            ),
                          );

                          return DropdownMenuItem(
                            value: allergy,
                            onTap: () {
                              if (allergyName == null) {
                                return;
                              }

                              if (isSelected) {
                                // remove on new allergies
                                setState(() {
                                  newMyAllergies.remove(allergyName);
                                });
                              } else {
                                // add on new allergies
                                setState(() {
                                  newMyAllergies.add(allergyName);
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.paddingHorizontal,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: isSelected
                                          ? colorScheme.primary
                                          : null,
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.surfaceDim,
                                      ),
                                    ),
                                    child: (isSelected)
                                        ? SvgPicture.asset(
                                            AssetIconsPath.icCheck,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      (allergy.allergy ?? '').toCapitalize(),
                                      style: textTheme.bodyMedium.copyWith(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurfaceDim,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder:
                            AllergyConfig.allAllergies.map((allergy) {
                          return Text(
                            context.locale.choose,
                            style: textTheme.bodyLarge.copyWith(
                              color: colorScheme.onSurfaceBright,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {},
                      ),
                      if (newMyAllergies.isNotEmpty) ...[
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "${context.locale.listOfAllergies}?",
                          style: textTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceDim,
                          ),
                        ),
                        Wrap(
                          runSpacing: 3,
                          spacing: 14,
                          children: newMyAllergies.map((allergy) {
                            return Chip(
                              label: Text(
                                allergy.toCapitalizes(),
                              ),
                              deleteIcon: SvgPicture.asset(
                                AssetIconsPath.icClose,
                                height: 8,
                              ),
                              onDeleted: () {
                                // remove on new allergies
                                setState(() {
                                  newMyAllergies.remove(allergy);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<EditAllergiesCubit, EditAllergiesState>(
                builder: (context, state) {
                  return ButtonWidget(
                    text: context.locale.save,
                    width: context.width,
                    isLoading: state is EditAllergiesLoading,
                    isDisabled: listEquals(newMyAllergies,
                        activeMyAllergies), // TODO: Bug when list has same but different sort
                    onTap: _onSave,
                  );
                },
              ),
              SizedBox(
                height: context.paddingBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    try {
      ProfileEntity? newProfile;
      if (widget.params is EditAllergiesPageParams) {
        newProfile = (widget.params as EditAllergiesPageParams).profile;
      }
      if (newProfile == null) {
        return;
      }

      // set allergies
      newProfile = newProfile.copyWith(
        isForceAllergies: true,
        allergies: (newMyAllergies.isEmpty) ? null : newMyAllergies.join(','),
      );

      // edit allergies
      await BlocProvider.of<EditAllergiesCubit>(context).editAllergies(
        userId: newProfile.userId,
        allergies: newProfile.allergies,
      );

      // sho success message
      context.showToast(
        type: ToastType.success,
        message: context.locale.successEditAllergies,
      );

      // update active my allergies
      setState(() {
        activeMyAllergies = List.from(newMyAllergies);
      });

      // update allergies state
      BlocProvider.of<ProfileCubit>(context).emitProfileData(
        newProfile,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
