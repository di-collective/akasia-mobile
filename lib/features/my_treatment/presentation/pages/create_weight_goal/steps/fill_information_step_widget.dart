import 'package:flutter/material.dart';

import '../../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../../core/ui/extensions/sex_extension.dart';
import '../../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../../../core/ui/widget/dividers/title_divider_widget.dart';
import '../../../../../../core/ui/widget/dropdowns/activity_level_dropdown_widget.dart';
import '../../../../../../core/ui/widget/forms/date_form_widget.dart';
import '../../../../../../core/ui/widget/forms/height_text_form_widget.dart';
import '../../../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import '../../../../../../core/ui/widget/radios/gender_radio_widget.dart';

class FillInformationStepWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController weightTextController;
  final TextEditingController weightGoalTextController;
  final TextEditingController dateOfBirthTextController;
  final DateTime? selectedDateOfBirth;
  final SexType? selectedSex;
  final TextEditingController heightTextController;
  final TextEditingController activityLevelTextController;
  final WeightGoalActivityLevel? selectedActivityLevel;
  final WeightGoalPace? selectedPace;

  final Function(DateTime?) onSelectedDateOfBirth;
  final Function(SexType?) onSelectedSexType;
  final Function(WeightGoalActivityLevel?) onSelectedActivityLevel;
  final Function() onReloadState;

  const FillInformationStepWidget({
    super.key,
    required this.formKey,
    required this.weightTextController,
    required this.weightGoalTextController,
    required this.dateOfBirthTextController,
    required this.selectedDateOfBirth,
    required this.selectedSex,
    required this.heightTextController,
    required this.activityLevelTextController,
    required this.selectedActivityLevel,
    required this.selectedPace,
    required this.onSelectedDateOfBirth,
    required this.onSelectedSexType,
    required this.onSelectedActivityLevel,
    required this.onReloadState,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingHorizontal,
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.07,
          ),
          Text(
            context.locale.personalInformation.toCapitalizes(),
            style: textTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceDim,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const TitleDividerWidget(),
          const SizedBox(
            height: 24,
          ),
          Text(
            "${context.locale.takeAGuessIfYouAreNotSure}.".toCapitalize(),
            textAlign: TextAlign.center,
            maxLines: 3,
            style: textTheme.labelMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  WeightTextFormWidget(
                    context: context,
                    controller: weightTextController,
                    title: context.locale.your(
                      context.locale.weight,
                    ),
                    isRequired: true,
                    onChanged: (_) {
                      // reload state
                      onReloadState();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  WeightTextFormWidget(
                    context: context,
                    controller: weightGoalTextController,
                    title: context.locale.weightGoal,
                    isRequired: true,
                    onChanged: (_) {
                      // reload state
                      onReloadState();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateFormWidget(
                    controller: dateOfBirthTextController,
                    title: context.locale.dateOfBirth,
                    hintText: context.locale.select(
                      context.locale.date,
                    ),
                    isRequired: true,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    initialDate: selectedDateOfBirth,
                    onSelectedDate: onSelectedDateOfBirth,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GenderRadioWidget(
                    title: context.locale.gender,
                    isRequired: true,
                    groupValue: selectedSex,
                    onChanged: onSelectedSexType,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  HeightTextFormWidget(
                    context: context,
                    controller: heightTextController,
                    title: context.locale.your(
                      context.locale.height,
                    ),
                    isRequired: true,
                    onChanged: (_) {
                      // reload state
                      onReloadState();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ActivityLevelDropdownWidget(
                    context: context,
                    title: context.locale.activityLevel,
                    hintText: context.locale.choose,
                    selectedValue: selectedActivityLevel,
                    isRequired: true,
                    onChanged: onSelectedActivityLevel,
                    validator: (val) {
                      if (val == null) {
                        return context.locale.cannotBeEmpty;
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
