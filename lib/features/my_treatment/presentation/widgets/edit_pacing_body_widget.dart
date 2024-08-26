import 'package:collection/collection.dart';
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
import '../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../core/ui/extensions/weight_goal_flag_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/weight_goal_pacing_entity.dart';
import '../cubit/simulation/simulation_cubit.dart';

class EditPacingBodyWidget extends StatelessWidget {
  final double? currentStartingWeight;
  final double? currentTargetWeight;
  final WeightGoalPace? currentPacing;
  final WeightGoalActivityLevel? currentActivityLevel;
  final Function(WeightGoalPace value) onSave;

  const EditPacingBodyWidget({
    super.key,
    required this.currentStartingWeight,
    required this.currentTargetWeight,
    required this.currentPacing,
    required this.currentActivityLevel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SimulationCubit>(),
      child: _Body(
        currentStartingWeight: currentStartingWeight,
        currentTargetWeight: currentTargetWeight,
        currentPacing: currentPacing,
        currentActivityLevel: currentActivityLevel,
        onSave: onSave,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final double? currentStartingWeight;
  final double? currentTargetWeight;
  final WeightGoalPace? currentPacing;
  final WeightGoalActivityLevel? currentActivityLevel;
  final Function(WeightGoalPace value) onSave;

  const _Body({
    required this.currentStartingWeight,
    required this.currentTargetWeight,
    required this.currentPacing,
    required this.currentActivityLevel,
    required this.onSave,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  WeightGoalPacingEntity? _selectedPacing;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // TODO: Check if last fecthed simulation is still valid with current data or not
    // get simulation
    _onGetSimulation();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;

    return BlocListener<SimulationCubit, SimulationState>(
      listener: (context, state) {
        if (widget.currentPacing == null) {
          return;
        }

        if (state is SimulationLoaded) {
          final pacings = state.simulation.pacing;
          if (pacings == null || pacings.isEmpty) {
            return;
          }

          final selectedPacing = pacings.firstWhereOrNull((element) {
            return element.pace == widget.currentPacing;
          });
          if (selectedPacing == null) {
            return;
          }

          setState(() {
            _selectedPacing = selectedPacing;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.locale.pacing.toCapitalizes(),
              style: textTheme.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SimulationCubit, SimulationState>(
              builder: (context, state) {
                if (state is SimulationLoaded) {
                  final pacings = state.simulation.pacing;
                  if (pacings == null || pacings.isEmpty) {
                    return const StateEmptyWidget();
                  }

                  return ListView.builder(
                    itemCount: pacings.length,
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final pacing = pacings[index];
                      final isSelected = pacing == _selectedPacing;

                      return _ItemWidget(
                        pacing: pacing,
                        flag: state.simulation.flag,
                        isSelected: isSelected,
                        onTap: _onTap,
                      );
                    },
                  );
                } else if (state is SimulationError) {
                  return StateErrorWidget(
                    description: state.error.message(context),
                  );
                }

                return ListView.separated(
                  itemCount: 3,
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ShimmerLoading.rectangular(
                      height: 62,
                      width: context.width,
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<SimulationCubit, SimulationState>(
              builder: (context, state) {
                return ButtonWidget(
                  text: context.locale.save,
                  isLoading: state is SimulationLoading,
                  isUseShimmerLoading: true,
                  isDisabled: _selectedPacing == null ||
                      _selectedPacing?.pace == widget.currentPacing,
                  width: context.width,
                  onTap: _onSave,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onGetSimulation() async {
    await BlocProvider.of<SimulationCubit>(context).getSimulation(
      startingWeight: widget.currentStartingWeight?.toString(),
      targetWeight: widget.currentTargetWeight?.toString(),
      activityLevel: widget.currentActivityLevel,
    );
  }

  void _onTap(WeightGoalPacingEntity value) {
    if (value == _selectedPacing) {
      return;
    }

    setState(() {
      _selectedPacing = value;
    });
  }

  void _onSave() {
    if (_selectedPacing?.pace == null) {
      return;
    }

    widget.onSave(_selectedPacing!.pace!);
  }
}

class _ItemWidget extends StatelessWidget {
  final WeightGoalPacingEntity pacing;
  final WeightGoalFlag? flag;
  final bool isSelected;
  final Function(WeightGoalPacingEntity value) onTap;

  const _ItemWidget({
    required this.pacing,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final dailyCaloriesBudget = pacing.dailyCaloriesBudget;
    String formmatedDailyCaloriesBudget = "0";
    if (dailyCaloriesBudget != null) {
      formmatedDailyCaloriesBudget = dailyCaloriesBudget.parseToString();
    }

    final targetDate = pacing.targetDate?.toDateTime();
    String formmatedTargetDate = "-";
    if (targetDate != null) {
      formmatedTargetDate = targetDate.formatDate(
            format: "dd MMM yyyy",
          ) ??
          "";
    }

    final formattedPacingTitle = pacing.pace?.title(
      flag: flag,
    );

    return InkWell(
      onTap: () {
        onTap(pacing);
      },
      overlayColor: MaterialStateProperty.all(colorScheme.primaryTonal),
      borderRadius: BorderRadius.circular(
        AppRadius.medium,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surfaceContainerDim : null,
          borderRadius: BorderRadius.circular(
            AppRadius.medium,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedPacingTitle?.toCapitalizes() ?? "",
              style: textTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceDim,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetIconsPath.icTakeoutDining,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      formmatedDailyCaloriesBudget,
                      style: textTheme.bodyMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetIconsPath.icCalendarToday,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        formmatedTargetDate,
                        style: textTheme.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
