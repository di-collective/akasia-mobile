import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../health/data/datasources/health_service.dart';
import '../../../health/presentation/cubit/daily_heart_rate/daily_heart_rate_cubit.dart';
import '../../../health/presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';
import '../../../health/presentation/cubit/daily_sleep/daily_sleep_cubit.dart';
import '../../../health/presentation/cubit/daily_steps/daily_steps_cubit.dart';
import '../../../health/presentation/cubit/daily_workouts/daily_workouts_cubit.dart';
import 'activity_item_widget.dart';

class HealthActivitiesWidget extends StatefulWidget {
  const HealthActivitiesWidget({super.key});

  @override
  State<HealthActivitiesWidget> createState() => _HealthActivitiesWidgetState();
}

class _HealthActivitiesWidgetState extends State<HealthActivitiesWidget> {
  bool? _isPermissionGranted;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    try {
      // request health permission
      final isPermissionGranted = await sl<HealthService>().requestPermission();
      setState(() {
        _isPermissionGranted = isPermissionGranted;
      });
      if (_isPermissionGranted != true) {
        // not allowed access on health application
        return;
      }

      // get daily steps
      BlocProvider.of<DailyStepsCubit>(context).getDailySteps();

      // get daily heart rate
      BlocProvider.of<DailyHeartRateCubit>(context).getDailyHeartRate();

      // get daily nutritions
      BlocProvider.of<DailyNutritionsCubit>(context).getDailyNutritions();

      // get daily workouts
      BlocProvider.of<DailyWorkoutsCubit>(context).getDailyWorkouts();

      // get daily sleep
      BlocProvider.of<DailySleepCubit>(context).getDailySleep();
    } catch (_) {
      rethrow;
    }
  }

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
        if (_isPermissionGranted == false) ...[
          StateErrorWidget(
            paddingTop: context.height * 0.05,
            width: context.width,
            description: _errorPermissionMessage,
            buttonText: context.locale.refresh,
            onTapButton: _onRefresh,
          ),
        ] else ...[
          BlocBuilder<DailyStepsCubit, DailyStepsState>(
            builder: (context, state) {
              List<double> data = [];
              if (state is DailyStepsLoaded) {
                data = state.data;
              }

              return ActivityWidget(
                iconPath: AssetIconsPath.icSteps,
                activity: context.locale.steps,
                value: "1.900",
                unit: "steps",
                time: "12:00",
                isInitial: state is DailyStepsInitial,
                isLoading: state is DailyStepsLoading,
                isError: state is DailyStepsError,
                data: data,
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
          BlocBuilder<DailySleepCubit, DailySleepState>(
            builder: (context, state) {
              List<double> data = [];
              String? hours;
              String? minutes;
              if (state is DailySleepLoaded) {
                data = state.data;
                hours = "5"; // TODO: Get hours
                minutes = "30"; // TODO: Get minutes
              }

              hours ??= "0";
              minutes ??= "0";

              return ActivityWidget(
                iconPath: AssetIconsPath.icBed,
                activity: context.locale.sleep,
                time: "12:00",
                isInitial: state is DailySleepInitial,
                isLoading: state is DailySleepLoading,
                isError: state is DailySleepError,
                data: data,
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
      ],
    );
  }

  String get _errorPermissionMessage {
    String item = "health";
    if (Platform.isIOS) {
      item = "HealthKit";
    } else if (Platform.isAndroid) {
      item = "Health Connect";
    }

    return context.locale.itemPermissionNotGranted(item);
  }

  Future<void> _onRefresh() async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      await _init();
    } catch (error) {
      context.showErrorToast(
        message: context.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
