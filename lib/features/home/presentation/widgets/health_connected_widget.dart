import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../health/domain/entities/heart_rate_activity_entity.dart';
import '../../../health/domain/entities/nutrition_activity_entity.dart';
import '../../../health/domain/entities/sleep_activity_entity.dart';
import '../../../health/domain/entities/steps_activity_entity.dart';
import '../../../health/presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../../../health/presentation/cubit/nutrition/nutrition_cubit.dart';
import '../../../health/presentation/cubit/sleep/sleep_cubit.dart';
import '../../../health/presentation/cubit/steps/steps_cubit.dart';
import '../../../health/presentation/cubit/workout/workout_cubit.dart';
import 'activity_item_widget.dart';

class HealthConnectedWidget extends StatefulWidget {
  const HealthConnectedWidget({super.key});

  @override
  State<HealthConnectedWidget> createState() => _HealthConnectedWidgetState();
}

class _HealthConnectedWidgetState extends State<HealthConnectedWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        BlocBuilder<StepsCubit, StepsState>(
          builder: (context, state) {
            List<StepsActivityEntity>? data;
            DateTime? checkedAt;
            int currentSteps = 0;
            if (state is StepsLoaded) {
              checkedAt = state.checkedAt;

              // get last seven data
              data = state.getLastSevenData();

              // get current steps
              if (data != null && data.isNotEmpty) {
                final value = data.last.count;
                if (value != null) {
                  currentSteps = value;
                }
              }
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icSteps,
              activity: context.locale.steps,
              value: currentSteps.formatNumber(
                locale: AppLocale.id.locale.countryCode,
              ),
              unit: context.locale.stepsUnit,
              time: checkedAt?.hourMinute,
              isLoading: state is StepsInitial || state is StepsLoading,
              isError: state is StepsError,
              data: data?.map((e) {
                return e.count?.toDouble() ?? 0;
              }).toList(),
              onTap: _onTapSteps,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<HeartRateCubit, HeartRateState>(
          builder: (context, state) {
            List<HeartRateActivityEntity>? data = [];
            DateTime? checkedAt;
            String currentHeartRate = "0";
            if (state is HeartRateLoaded) {
              checkedAt = state.checkedAt;

              // get last seven data
              data = state.getLastSevenData();

              // get current heart rate
              if (data != null && data.isNotEmpty) {
                final value = data.last.value;
                if (value != null) {
                  currentHeartRate = value.toString();
                }
              }
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icHeartRate,
              activity: context.locale.heartRate,
              value: currentHeartRate,
              unit: context.locale.heartRateUnit,
              unitIconPath: AssetIconsPath.icLove,
              time: checkedAt?.hourMinute,
              isLoading: state is HeartRateInitial || state is HeartRateLoading,
              isError: state is HeartRateError,
              data: data?.map((e) {
                return e.value?.toDouble() ?? 0;
              }).toList(),
              onTap: _onHeartRate,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<NutritionCubit, NutritionState>(
          builder: (context, state) {
            List<NutritionActivityEntity>? data;
            DateTime? checkedAt;
            int currentNutrition = 0;
            if (state is NutritionLoaded) {
              checkedAt = state.checkedAt;

              // get last seven data
              data = state.getLastSevenData();

              // get current steps
              if (data != null && data.isNotEmpty) {
                final value = data.last.value;
                if (value != null) {
                  currentNutrition = value.toInt();
                }
              }
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icFish,
              activity: context.locale.nutritions,
              value: currentNutrition.toString(),
              unit: "cal",
              time: checkedAt?.hourMinute,
              isLoading: state is NutritionInitial || state is NutritionLoading,
              isError: state is NutritionError,
              onTap: _onNutrition,
              data: data?.map((e) {
                return e.value ?? 0;
              }).toList(),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            List<double> data = [];
            DateTime? checkedAt;
            Duration currentWorkoutTime = const Duration();
            if (state is WorkoutLoaded) {
              checkedAt = state.checkedAt;

              // get last seven data
              final lastSevenData = state.getLastSevenData();

              // get current workout time
              if (lastSevenData.isNotEmpty) {
                final fromDate = lastSevenData.last.fromDate;
                final toDate = lastSevenData.last.toDate;

                if (fromDate != null && toDate != null) {
                  currentWorkoutTime = toDate.difference(fromDate);
                }
              }

              // get data for chart
              for (final item in lastSevenData) {
                final fromDate = item.fromDate;
                final toDate = item.toDate;

                if (fromDate != null && toDate != null) {
                  data.add(toDate.difference(fromDate).inMinutes.toDouble());
                }
              }
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icWorkout,
              activity: context.locale.workouts,
              value: currentWorkoutTime.inMinutes.toString(),
              unit: "min",
              time: checkedAt?.hourMinute,
              isLoading: state is WorkoutInitial || state is WorkoutLoading,
              isError: state is WorkoutError,
              data: data,
              onTap: _onWorkout,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<SleepCubit, SleepState>(
          builder: (context, state) {
            List<SleepActivityEntity>? data = [];
            DateTime? checkedAt;
            String hours = "0";
            String minutes = "0";
            if (state is SleepLoaded) {
              checkedAt = state.checkedAt;

              // get last seven data
              data = state.getLastSevenData();

              // get current sleep duration
              if (data != null && data.isNotEmpty) {
                final fromDate = data.last.fromDate;
                final toDate = data.last.toDate;

                if (fromDate != null && toDate != null) {
                  final lastSleepDuration = toDate.difference(fromDate);

                  hours = lastSleepDuration.inHours.toString();
                  minutes = lastSleepDuration.remainingMinutes;
                }
              }
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icBed,
              activity: context.locale.sleep,
              time: checkedAt?.hourMinute,
              isLoading: state is SleepInitial || state is SleepLoading,
              isError: state is SleepError,
              onTap: _onTapSleep,
              data: data?.map((e) {
                final fromDate = e.fromDate;
                final toDate = e.toDate;

                if (fromDate != null && toDate != null) {
                  return toDate.difference(fromDate).inHours.toDouble();
                }

                return 0.0;
              }).toList(),
              valueWidget: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hours,
                    style: textTheme.headlineLarge.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(
                      "h",
                      style: textTheme.bodySmall.copyWith(
                        color: colorScheme.onSurfaceBright,
                      ),
                    ),
                  ),
                  Text(
                    minutes,
                    style: textTheme.headlineLarge.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(
                      "min",
                      style: textTheme.bodySmall.copyWith(
                        color: colorScheme.onSurfaceBright,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _onTapSteps() {
    // go to steps page
    context.goNamed(AppRoute.steps.name);
  }

  void _onTapSleep() {
    // go to sleep page
    context.goNamed(AppRoute.sleep.name);
  }

  void _onHeartRate() {
    // go to heart rate page
    context.goNamed(AppRoute.heartRate.name);
  }

  void _onWorkout() {
    // go to workout page
    context.goNamed(AppRoute.workout.name);
  }

  void _onNutrition() {
    // go to nutrition page
    context.goNamed(AppRoute.nutrition.name);
  }
}
