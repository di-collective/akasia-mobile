import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/option_button_item_widget.dart';
import '../cubit/weight_goal/weight_goal_cubit.dart';

class EditWeightGoalPage extends StatefulWidget {
  const EditWeightGoalPage({super.key});

  @override
  State<EditWeightGoalPage> createState() => _EditWeightGoalPageState();
}

class _EditWeightGoalPageState extends State<EditWeightGoalPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.weightGoal.toCapitalizes(),
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: BlocBuilder<WeightGoalCubit, WeightGoalState>(
        builder: (context, state) {
          String formmatedStartDate = "";
          String formmatedStartWeight = "0";
          String formmatedCurrentWeight =
              "0"; // TODO: Get latest from weight history
          String formmatedGoalWeight = "0";
          String formmatedActivityLevel = "";
          String formmatedPacing = "";
          String formmatedTargetDate = "";
          String formattedCaloriesToMaintain = "0";
          if (state is WeightGoalLoaded) {
            final startDate = state.weightGoal?.startingDate?.toDateTime();
            if (startDate != null) {
              formmatedStartDate = startDate.formatDate(
                    format: "dd MMM yyyy",
                  ) ??
                  "";
            }

            final startWeight = state.weightGoal?.startingWeight;
            if (startWeight != null) {
              formmatedStartWeight = startWeight.parseToString;
            }

            final goalWeight = state.weightGoal?.targetWeight;
            if (goalWeight != null) {
              formmatedGoalWeight = goalWeight.parseToString;
            }

            final activityLevel = state.weightGoal?.activityLevel;
            if (activityLevel != null) {
              formmatedActivityLevel = activityLevel.toCapitalizes();
            }

            final pacing = state.weightGoal?.pace;
            if (pacing != null) {
              formmatedPacing = pacing.title;
            }

            final targetDate = state.weightGoal?.targetDate?.toDateTime();
            if (targetDate != null) {
              formmatedTargetDate = targetDate.formatDate(
                    format: "dd MMMM yyyy",
                  ) ??
                  "";
            }

            final caloriesToMaintain = state.weightGoal?.caloriesToMaintain;
            if (caloriesToMaintain != null) {
              formattedCaloriesToMaintain = caloriesToMaintain.parseToString;
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingHorizontal,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                OptionsButtonWidget(
                  items: [
                    OptionButtonItem(
                      label: context.locale
                          .startItem(
                            context.locale.date,
                          )
                          .toCapitalizes(),
                      description: formmatedStartDate,
                      onTap: _onStartDate,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                OptionsButtonWidget(
                  items: [
                    OptionButtonItem(
                      label: context.locale
                          .startItem(
                            context.locale.weight,
                          )
                          .toCapitalizes(),
                      description: "$formmatedStartWeight kgs",
                      onTap: _onStartWeight,
                    ),
                    OptionButtonItem(
                      label: context.locale
                          .currentItem(
                            context.locale.weight,
                          )
                          .toCapitalizes(),
                      description: "$formmatedCurrentWeight kgs",
                      onTap: _onCurrentWeight,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                OptionsButtonWidget(
                  items: [
                    OptionButtonItem(
                      label: context.locale
                          .goalItem(
                            context.locale.weight,
                          )
                          .toCapitalizes(),
                      description: "$formmatedGoalWeight kgs",
                      onTap: _onGoalWeight,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                OptionsButtonWidget(
                  items: [
                    OptionButtonItem(
                      label: context.locale.activityLevel,
                      description: formmatedActivityLevel,
                      onTap: _onActivityLevel,
                    ),
                    OptionButtonItem(
                      label: context.locale.pacing.toCapitalizes(),
                      description: formmatedPacing,
                      onTap: _onPacing,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.white,
                    borderRadius: BorderRadius.circular(
                      AppRadius.large,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AssetIconsPath.icWarningCircle,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    "Based on your goals, you are projected to reach your goal on ",
                              ),
                              TextSpan(
                                text: formmatedTargetDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(text: ", "),
                              const TextSpan(
                                  text: " with daily calorie budget of "),
                              TextSpan(
                                text: formattedCaloriesToMaintain,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(text: "."),
                            ],
                          ),
                          maxLines: 5,
                          style: textTheme.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceDim,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.paddingBottom,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onStartDate() async {
    // TODO: Implement _onStartDate
  }

  Future<void> _onStartWeight() async {
    // TODO: Implement _onStartWeight
  }

  Future<void> _onCurrentWeight() async {
    // TODO: Implement _onCurrentWeight
  }

  Future<void> _onGoalWeight() async {
    // TODO: Implement _onGoalWeight
  }

  Future<void> _onActivityLevel() async {
    // TODO: Implement _onActivityLevel
  }

  Future<void> _onPacing() async {
    // TODO: Implement _onPacing
  }
}
