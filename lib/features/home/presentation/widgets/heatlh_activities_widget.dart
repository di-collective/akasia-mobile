import 'package:akasia365mc/features/home/presentation/widgets/health_initial_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../health/presentation/cubit/health_service/health_service_cubit.dart';
import '../../../health/presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../../../health/presentation/cubit/nutrition/nutrition_cubit.dart';
import '../../../health/presentation/cubit/sleep/sleep_cubit.dart';
import '../../../health/presentation/cubit/steps/steps_cubit.dart';
import '../../../health/presentation/cubit/workout/workout_cubit.dart';
import 'health_connected_widget.dart';
import 'health_disconnected_widget.dart';

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

    return BlocListener<HealthServiceCubit, HealthServiceState>(
      listener: (context, state) {
        if (state is HealthServiceConnected) {
          // get health data
          _getHealthData;
        }
      },
      child: Column(
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
          BlocBuilder<HealthServiceCubit, HealthServiceState>(
            builder: (context, state) {
              if (state is HealthServiceLoading) {
                return const HealthConnectedWidget();
              } else if (state is HealthServiceDisconnected) {
                return const HealthDisconnectedWidget();
              } else if (state is HealthServiceConnected) {
                return const HealthConnectedWidget();
              }

              return const HealthInitialWidget();
            },
          ),
        ],
      ),
    );
  }

  void get _getHealthData {
    // get steps
    BlocProvider.of<StepsCubit>(context).getStepsInOneWeek();

    // get heart rate
    BlocProvider.of<HeartRateCubit>(context).getHeartRateInOneWeek();

    // get nutritions
    BlocProvider.of<NutritionCubit>(context).getNutritionInOneWeek();

    // get workouts
    BlocProvider.of<WorkoutCubit>(context).getWorkoutInOneWeek();

    // get sleep
    BlocProvider.of<SleepCubit>(context).getSleepInOneWeek();
  }
}
