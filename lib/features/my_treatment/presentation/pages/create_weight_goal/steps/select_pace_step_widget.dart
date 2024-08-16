import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/config/asset_path.dart';
import '../../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../../../core/ui/theme/dimens.dart';
import '../../../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../../../core/ui/widget/dividers/title_divider_widget.dart';
import '../../../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../domain/entities/weight_goal_pacing_entity.dart';
import '../../../cubit/simulation/simulation_cubit.dart';

class SelectPaceStepWidget extends StatefulWidget {
  final WeightGoalPace? selectedPace;
  final Function(WeightGoalPacingEntity) onSelectedPace;
  final Function() onCreateWeightGoal;

  const SelectPaceStepWidget({
    super.key,
    required this.selectedPace,
    required this.onSelectedPace,
    required this.onCreateWeightGoal,
  });

  @override
  State<SelectPaceStepWidget> createState() => _SelectPaceStepWidgetState();
}

class _SelectPaceStepWidgetState extends State<SelectPaceStepWidget> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _pageController = PageController(
      initialPage: widget.selectedPace?.index ?? 0,
      viewportFraction: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        SizedBox(
          height: context.height * 0.07,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Text(
            context.locale.selectAWeightLossPlan.toCapitalize(),
            textAlign: TextAlign.center,
            maxLines: 3,
            style: textTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceDim,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleDividerWidget(),
        const SizedBox(
          height: 80,
        ),
        SizedBox(
          height: 284,
          child: BlocBuilder<SimulationCubit, SimulationState>(
            builder: (context, state) {
              List<WeightGoalPacingEntity> pacings = [];
              if (state is SimulationLoaded) {
                pacings = state.simulation.pacing ?? [];
              }

              if (pacings.isEmpty) {
                return const StateEmptyWidget();
              }

              return PageView.builder(
                controller: _pageController,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                itemCount: pacings.length,
                itemBuilder: (context, index) {
                  final pacing = pacings[index];
                  final pace =
                      WeightGoalPace.values.firstOrNullWhere((element) {
                    return element == pacing.pace;
                  });

                  final isFirst = index == 0;
                  final isLast = index == WeightGoalPace.values.length - 1;
                  final loosPerWeek = pace?.losePerWeek;
                  final dailyCaloriesBudget = pacing.dailyCaloriesBudget;
                  final targetDate = pacing.targetDate?.toDateTime();
                  final rangeInWeeks = targetDate?.dateRangeInWeeks(
                    startDate: DateTime.now(),
                  );

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isFirst ? 16 : 8,
                      right: isLast ? 16 : 0,
                    ),
                    child: Container(
                      height: 284,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppRadius.extraLarge),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              pacing.pace?.title ?? "",
                              style: textTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurfaceDim,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              pacing.pace?.description ?? "",
                              maxLines: 3,
                              style: textTheme.bodyMedium.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _DetailItemWidget(
                            iconPath: AssetIconsPath.icArrowCircleDown,
                            text: "Loss ${loosPerWeek ?? ""} per week",
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          _DetailItemWidget(
                            iconPath: AssetIconsPath.icTakeoutDining,
                            text: "Eat $dailyCaloriesBudget calories per day",
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          _DetailItemWidget(
                            iconPath: AssetIconsPath.icCalendarToday,
                            text: "About $rangeInWeeks weeks to reach goal",
                          ),
                          const Spacer(),
                          ButtonWidget(
                            text: context.locale.select(''),
                            width: context.width,
                            onTap: () {
                              _onSelect(
                                pacing: pacing,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSelect({
    required WeightGoalPacingEntity pacing,
  }) {
    // set selected pacing
    widget.onSelectedPace(pacing);

    // create weight goal
    widget.onCreateWeightGoal();
  }
}

class _DetailItemWidget extends StatelessWidget {
  final String iconPath;
  final String text;

  const _DetailItemWidget({
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            style: textTheme.labelMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
