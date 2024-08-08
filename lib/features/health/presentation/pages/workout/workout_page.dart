import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_route.dart';
import '../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../../core/ui/extensions/duration_extension.dart';
import '../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../../core/ui/theme/dimens.dart';
import '../../../../../core/ui/widget/images/network_image_widget.dart';
import '../../cubit/workout/workout_cubit.dart';
import '../../widgets/option_button_item_widget.dart';
import '../../widgets/weekly_chart_widget.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.workouts,
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            BlocBuilder<WorkoutCubit, WorkoutState>(
              builder: (context, state) {
                final List<DateTime> dates = [];
                final List<BarChartGroupData> barGroups = [];
                int averageWorkoutDuration = 0;
                String averageWorkoutDurationUnit = "hr";
                if (state is WorkoutLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek.isNotEmpty) {
                    List<int> workoutDurationInMinutes = [];
                    for (final dayEntry in dataInWeek.entries) {
                      // add day
                      dates.add(dayEntry.key);

                      // calculte workout duration in minutes
                      int currentDayDurationInMinutes = 0;
                      for (final workout in dayEntry.value) {
                        final fromDate = workout.fromDate;
                        final toDate = workout.toDate;
                        if (fromDate != null && toDate != null) {
                          final duration = toDate.difference(fromDate);

                          workoutDurationInMinutes.add(duration.inMinutes);
                          currentDayDurationInMinutes += duration.inMinutes;
                        }
                      }

                      // add data to chart
                      barGroups.add(
                        BarChartGroupData(
                          x: barGroups.length,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: currentDayDurationInMinutes.toDouble(),
                              color: colorScheme.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              width: 25,
                            ),
                          ],
                        ),
                      );
                    }

                    if (workoutDurationInMinutes.isNotEmpty) {
                      // calculate average duration
                      final total = workoutDurationInMinutes.sum();
                      final totalDuration = Duration(
                        minutes: total ~/ workoutDurationInMinutes.length,
                      );

                      if (totalDuration.inHours > 0) {
                        averageWorkoutDuration = totalDuration.inHours;
                        averageWorkoutDurationUnit = "hr";
                      } else {
                        averageWorkoutDuration = totalDuration.inMinutes;
                        averageWorkoutDurationUnit = "min";
                      }
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  barGroups: barGroups,
                  average: averageWorkoutDuration.toString(),
                  unit: averageWorkoutDurationUnit,
                  rightTitleUnit: "min",
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final duration = Duration(
                      minutes: rod.toY.toInt(),
                    );
                    final remainingMinutes = duration.remainingMinutes;
                    final date = dates[group.x.toInt()];

                    return BarTooltipItem(
                      textAlign: TextAlign.start,
                      duration.inHours.toString(),
                      textTheme.titleMedium.copyWith(
                        color: colorScheme.onSurfaceDim,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'h ',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                        TextSpan(
                          text: remainingMinutes,
                          style: textTheme.titleMedium.copyWith(
                            color: colorScheme.onSurfaceDim,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'min',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                        TextSpan(
                          text: '\n${date.formatDate(format: 'dd MMM yyyy')}',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: _onTenDaysWorkout,
              child: NetworkImageWidget(
                size: Size(context.width, 147),
                fit: BoxFit.cover,
                opcatity: 0.4,
                borderRadius: BorderRadius.circular(
                  AppRadius.large,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        context.locale.workoutsRecommendationsForYou,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.white,
                        ),
                      ),
                      Text(
                        "10 ${context.locale.daysWorkout}",
                        style: textTheme.titleSmall.copyWith(
                          color: colorScheme.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              context.locale.options,
              style: textTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceDim,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            OptionButtonItemWidget(
              title: context.locale.showAllData,
              onTap: _onShowAllData,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            const Divider(),
            OptionButtonItemWidget(
              title: context.locale.dataSourceAndAccess,
              onTap: _onDataSourceAndAccess,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onTenDaysWorkout() {
    // go to ten days workout page
    context.goNamed(AppRoute.tenDaysWorkout.name);
  }

  void _onShowAllData() {
    // go to show all data page
    context.goNamed(AppRoute.allWorkoutData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
