import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/options_button_widget.dart';
import '../../../../core/ui/widget/dialogs/bottom_sheet_info.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/weight_goal_entity.dart';
import '../../domain/entities/weight_history_entity.dart';
import '../cubit/weight_goal/weight_goal_cubit.dart';
import '../cubit/weight_history/weight_history_cubit.dart';
import '../widgets/edit_current_weight_body_widget.dart';
import '../widgets/edit_start_weight_body_widget.dart';

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
          DateTime? startDate;
          String formmatedStartDate = "";
          String formmatedStartWeight = "0";
          bool isStartDateSameAsToday = false;

          String formmatedGoalWeight = "0";
          String formmatedActivityLevel = "";
          String formmatedPacing = "";
          String formmatedTargetDate = "";
          String formattedCaloriesToMaintain = "0";

          if (state is WeightGoalLoaded) {
            startDate = state.weightGoal?.startingDate?.toDateTime();
            if (startDate != null) {
              formmatedStartDate = startDate.formatDate(
                    format: "dd MMM yyyy",
                  ) ??
                  "";

              isStartDateSameAsToday = startDate.isSame(
                other: DateTime.now(),
                withoutHour: true,
                withoutSecond: true,
              );
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
                    format: "MMMM dd, yyyy",
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
                      onTap: () => _onStartDate(
                        currentStartDate: startDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<WeightHistoryCubit, WeightHistoryState>(
                  builder: (context, state) {
                    WeightHistoryEntity? latestHistory;
                    String formmatedCurrentWeight = "0";
                    if (state is WeightHistoryLoaded) {
                      latestHistory = state.latestHistory;
                      if (latestHistory != null) {
                        final weight = latestHistory.weight?.parseToString;
                        if (weight != null) {
                          formmatedCurrentWeight = weight;
                        }
                      }
                    }

                    return OptionsButtonWidget(
                      items: [
                        OptionButtonItem(
                          label: context.locale
                              .startItem(
                                context.locale.weight,
                              )
                              .toCapitalizes(),
                          description: "$formmatedStartWeight kgs",
                          isDisabled: isStartDateSameAsToday,
                          onTap: _onStartWeight,
                        ),
                        OptionButtonItem(
                          label: context.locale
                              .currentItem(
                                context.locale.weight,
                              )
                              .toCapitalizes(),
                          description: "$formmatedCurrentWeight kgs",
                          onTap: () => _onCurrentWeight(
                            currentWeightDate: latestHistory?.date,
                            currentWeight: latestHistory?.weight,
                          ),
                        ),
                      ],
                    );
                  },
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
                                  text: "with daily calorie budget of "),
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

  Future<void> _onStartDate({
    required DateTime? currentStartDate,
  }) async {
    try {
      final now = DateTime.now();

      final selectedDate = await context.selectDate(
        initialDate: currentStartDate,
        firstDate: now.addYears(-2),
        lastDate: now,
      );
      if (selectedDate == null ||
          selectedDate.isSame(
            other: currentStartDate,
            withoutHour: true,
            withoutSecond: true,
          )) {
        return;
      }

      // TODO: if weight on selected date is null, show _onStartWeight to fill it
      context.showWarningToast(
        message:
            "Your weight on this date is not available. Please fill weight on selected date.",
      );
      final isSuccess = await _onStartWeight(
        newStartingDate: selectedDate, // also update starting date
      );
      if (isSuccess != true) {
        return;
      }

      // // update weight goal
      // await _onUpdateWeightGoal(
      //   startingDate: selectedDate,
      // );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> _onStartWeight({
    DateTime? newStartingDate,
  }) async {
    try {
      // show confirmation dialog
      return await sl<BottomSheetInfo>().showMaterialModal(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsetsBottom,
            ),
            child: EditStartWeightBodyWidget(
              onSave: (value) async {
                final isSuccess = await _onUpdateWeightGoal(
                  startingWeight: value.parseToDouble,
                  startingDate: newStartingDate,
                );
                if (isSuccess != true) {
                  return;
                }

                // close dialog
                Navigator.of(context).pop(isSuccess);
              },
            ),
          );
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _onCurrentWeight({
    required DateTime? currentWeightDate,
    required double? currentWeight,
  }) async {
    try {
      // show confirmation dialog
      return await sl<BottomSheetInfo>().showMaterialModal(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsetsBottom,
            ),
            child: EditCurrentWeightBodyWidget(
              defaultValue: currentWeight,
              onSave: (value) async {
                final isSuccess = await _onUpdateCurrentWeight(
                  currentWeightDate: currentWeightDate,
                  newCurrentWeight: value.parseToDouble,
                );
                if (isSuccess != true) {
                  return;
                }

                // close dialog
                Navigator.of(context).pop(isSuccess);
              },
            ),
          );
        },
      );
    } catch (_) {
      rethrow;
    }
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

  Future<bool?> _onUpdateWeightGoal({
    DateTime? startingDate,
    double? startingWeight,
    double? targetWeight,
    String? activityLevel,
    WeightGoalPace? pace,
  }) async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      final newWeightGoal = WeightGoalEntity(
        startingDate: startingDate?.formatDate(
          format: "yyyy-MM-dd",
        ),
        startingWeight: startingWeight,
        targetWeight: targetWeight,
        activityLevel: activityLevel,
        pace: pace,
      );
      if (newWeightGoal.isNull) {
        return null;
      }

      // update weight goal
      await BlocProvider.of<WeightGoalCubit>(context).updateWeightGoal(
        newWeightGoal: newWeightGoal,
      );

      return true;
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return false;
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }

  Future<bool?> _onUpdateCurrentWeight({
    required DateTime? currentWeightDate,
    required double? newCurrentWeight,
  }) async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      // update current weight
      final weightDate =
          currentWeightDate ?? DateTime.now(); // if null, use today
      await BlocProvider.of<WeightHistoryCubit>(context).updateWeight(
        weight: newCurrentWeight,
        date: weightDate,
      );

      return true;
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return false;
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
