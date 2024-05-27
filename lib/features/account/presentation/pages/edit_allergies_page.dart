import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/config/allery_config.dart';
import '../../../../app/config/asset_path.dart';
import '../../../../app/di/depedency_injection.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dropdowns/dropdown_widget.dart';
import '../../data/models/allergy_model.dart';
import '../cubit/allergies/allergies_cubit.dart';
import '../cubit/edit_allergies/edit_allergies_cubit.dart';

class EditAllergiesPageParams {
  final List<AllergyModel>? allergies;

  EditAllergiesPageParams({
    required this.allergies,
  });
}

class EditAllergiesPage<T> extends StatelessWidget {
  final T? params;

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

class _Body<T> extends StatefulWidget {
  final T? params;

  const _Body({
    this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  List<AllergyModel> activeMyAllergies = [];
  List<AllergyModel> newMyAllergies = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // set my allergies
    final paramsAllergies =
        (widget.params as EditAllergiesPageParams).allergies;
    if (paramsAllergies != null) {
      activeMyAllergies = List.from(paramsAllergies);
      newMyAllergies = List.from(paramsAllergies);
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
                      DropdownWidget<AllergyModel>(
                        selectedValue: null,
                        hintText: context.locale.choose,
                        items: AllergyConfig.allAllergies.map((allergy) {
                          final isSelected = newMyAllergies.any(
                            (element) => element.id == allergy.id,
                          );

                          return DropdownMenuItem(
                            value: allergy,
                            onTap: () {
                              if (isSelected) {
                                // remove on new allergies
                                setState(() {
                                  newMyAllergies.remove(allergy);
                                });
                              } else {
                                // add on new allergies
                                setState(() {
                                  newMyAllergies.add(allergy);
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
                              (allergy.allergy ?? '').toCapitalize(),
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
      // edit allergies
      await BlocProvider.of<EditAllergiesCubit>(context).editAllergies(
        allergies: newMyAllergies,
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

      // update allergies
      BlocProvider.of<AllergiesCubit>(context).updateAllergies(
        newMyAllergies,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
