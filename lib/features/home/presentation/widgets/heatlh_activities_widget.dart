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
import '../../../health/domain/entities/activity_entity.dart';
import '../../../health/domain/entities/sleep_activity_entity.dart';
import '../../../health/domain/entities/steps_activity_entity.dart';
import '../../../health/presentation/cubit/daily_heart_rate/daily_heart_rate_cubit.dart';
import '../../../health/presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';
import '../../../health/presentation/cubit/daily_workouts/daily_workouts_cubit.dart';
import '../../../health/presentation/cubit/sleep/sleep_cubit.dart';
import '../../../health/presentation/cubit/steps/steps_cubit.dart';
import 'activity_item_widget.dart';

class HealthActivitiesWidget extends StatefulWidget {
  const HealthActivitiesWidget({super.key});

  @override
  State<HealthActivitiesWidget> createState() => _HealthActivitiesWidgetState();
}

class _HealthActivitiesWidgetState extends State<HealthActivitiesWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.summary,
          style: textTheme.titleMedium.copyWith(
            color: colorScheme.onSurfaceDim,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // TODO: Handle if permission not granted
        // StateErrorWidget(
        //   paddingTop: context.height * 0.05,
        //   width: context.width,
        //   description: _errorPermissionMessage,
        //   buttonText: context.locale.refresh,
        //   onTapButton: _onRefresh,
        // ),
        BlocBuilder<StepsCubit, StepsState>(
          builder: (context, state) {
            ActivityEntity<List<StepsActivityEntity>>? steps;
            List<StepsActivityEntity>? data;
            DateTime? updatedAt;
            int? todaySteps;
            if (state is StepsLoaded) {
              steps = state.steps;
              data = state.getLastOneWeekData();
              updatedAt = steps?.updatedAt;
              todaySteps = state.todaySteps?.count;
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icSteps,
              activity: context.locale.steps,
              value: todaySteps?.formatNumber(
                    locale: AppLocale.id.locale.countryCode,
                  ) ??
                  "0",
              unit: context.locale.stepsUnit,
              time: updatedAt?.hourMinute ?? "",
              isInitial: state is StepsInitial,
              isLoading: state is StepsLoading,
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
        BlocBuilder<DailyHeartRateCubit, DailyHeartRateState>(
          builder: (context, state) {
            List<double> data = [];
            if (state is DailyHeartRateLoaded) {
              data = state.data;
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icHeartRate,
              activity: context.locale.heartRate,
              value: "68",
              unit: "bpm",
              unitIconPath: AssetIconsPath.icLove,
              time: "12:00",
              isInitial: state is DailyHeartRateInitial,
              isLoading: state is DailyHeartRateLoading,
              isError: state is DailyHeartRateError,
              data: data,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<DailyNutritionsCubit, DailyNutritionsState>(
          builder: (context, state) {
            List<double> data = [];
            if (state is DailyNutritionsLoaded) {
              data = state.data;
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icFish,
              activity: context.locale.nutritions,
              value: "800",
              unit: "kcal",
              time: "12:00",
              isInitial: state is DailyNutritionsInitial,
              isLoading: state is DailyNutritionsLoading,
              isError: state is DailyNutritionsError,
              data: data,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<DailyWorkoutsCubit, DailyWorkoutsState>(
          builder: (context, state) {
            List<double> data = [];
            if (state is DailyWorkoutsLoaded) {
              data = state.data;
            }

            return ActivityWidget(
              iconPath: AssetIconsPath.icWorkout,
              activity: context.locale.workouts,
              value: "30",
              unit: "min",
              time: "12:00",
              isInitial: state is DailyWorkoutsInitial,
              isLoading: state is DailyWorkoutsLoading,
              isError: state is DailyWorkoutsError,
              data: data,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<SleepCubit, SleepState>(
          builder: (context, state) {
            ActivityEntity<List<SleepActivityEntity>>? sleep;
            List<SleepActivityEntity>? data = [];
            DateTime? updatedAt;
            String hours = "0";
            String minutes = "0";
            if (state is SleepLoaded) {
              sleep = state.sleep;
              data = state.getLastSevenData();
              updatedAt = sleep?.updatedAt;

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
              time: updatedAt?.hourMinute ?? "",
              isInitial: state is SleepInitial,
              isLoading: state is SleepLoading,
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

  // String get _errorPermissionMessage {
  //   String item = "health";
  //   if (Platform.isIOS) {
  //     item = "HealthKit";
  //   } else if (Platform.isAndroid) {
  //     item = "Health Connect";
  //   }

  //   return context.locale.itemPermissionNotGranted(item);
  // }

  // Future<void> _onRefresh() async {
  //   try {
  //     // show full screen loading
  //     context.showFullScreenLoading();

  //     // request health permission
  //     final isPermissionGranted = await sl<HealthService>().requestPermission();
  //     if (isPermissionGranted != true) {
  //       // not allowed access on health application
  //       return;
  //     }

  //     // get steps
  //     BlocProvider.of<StepsCubit>(context).getStepsInOneWeek();

  //     // get daily heart rate
  //     BlocProvider.of<DailyHeartRateCubit>(context).getDailyHeartRate();

  //     // get daily nutritions
  //     BlocProvider.of<DailyNutritionsCubit>(context).getDailyNutritions();

  //     // get daily workouts
  //     BlocProvider.of<DailyWorkoutsCubit>(context).getDailyWorkouts();

  //     // get daily sleep
  //     BlocProvider.of<SleepCubit>(context).getSleep();
  //   } catch (error) {
  //     context.showErrorToast(
  //       message: context.message(context),
  //     );
  //   } finally {
  //     // hide full screen loading
  //     context.hideFullScreenLoading;
  //   }
  // }

  void _onTapSteps() {
    // go to steps page
    context.goNamed(AppRoute.steps.name);
  }

  void _onTapSleep() {
    // go to sleep page
    context.goNamed(AppRoute.sleep.name);
  }
}
