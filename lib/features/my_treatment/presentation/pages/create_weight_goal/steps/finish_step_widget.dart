import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/config/asset_path.dart';
import '../../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../../../core/ui/extensions/double_extension.dart';
import '../../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../../../core/ui/extensions/weight_goal_flag_extension.dart';
import '../../../../../../core/ui/widget/dividers/title_divider_widget.dart';
import '../../../cubit/weight_goal/weight_goal_cubit.dart';

class FinishStepWidget extends StatelessWidget {
  const FinishStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        String formmatedWeightGoal = "0";
        String formmatedTargetDate = "";
        WeightGoalFlag formmatedFlag = WeightGoalFlag.loss;
        String formattedCaloriesToMaintain = "0";

        if (state is WeightGoalLoaded) {
          final weightGoal = state.weightGoal?.targetWeight;
          if (weightGoal != null) {
            formmatedWeightGoal = weightGoal.parseToString();
          }

          final flag = state.weightGoal?.flag;
          if (flag != null) {
            formmatedFlag = flag;
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
            formattedCaloriesToMaintain = caloriesToMaintain.parseToString();
          }
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.06,
              ),
              Text(
                context.locale.wePredictThatYouWillBe.toCapitalizes(),
                style: textTheme.bodyLarge.copyWith(
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${formmatedWeightGoal}kg",
                      style: TextStyle(
                        color: colorScheme.primary,
                      ),
                    ),
                    const TextSpan(text: " by "),
                    TextSpan(
                      text: formmatedTargetDate,
                      style: TextStyle(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TitleDividerWidget(
                color: colorScheme.onSurfaceDim,
                width: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    _chartPath(
                      flag: formmatedFlag,
                    ),
                    width: context.width,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today',
                          style: textTheme.bodyLarge.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          formmatedTargetDate,
                          style: textTheme.bodyLarge.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.locale.yourPlanIsReady.toCapitalizes(),
                style: textTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingHorizontal,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.locale.yourBudgetCalories(
                          formattedCaloriesToMaintain,
                        ),
                      ),
                      const TextSpan(text: ". "),
                      TextSpan(
                        text: context.locale.ifYourConsistenlyEatAnAverage(
                          formattedCaloriesToMaintain,
                        ),
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  String _chartPath({
    required WeightGoalFlag flag,
  }) {
    switch (flag) {
      case WeightGoalFlag.loss:
        return AssetImagesPath.dietChartDown;
      case WeightGoalFlag.gain:
        return AssetImagesPath.dietChartUp;
    }
  }
}
