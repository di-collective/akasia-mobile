import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/option_button_item_widget.dart';
import '../cubit/sleep/sleep_cubit.dart';
import '../widgets/weekly_chart_widget.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.sleep,
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
            BlocBuilder<SleepCubit, SleepState>(
              builder: (context, state) {
                final List<DateTime> dates = [];
                final List<BarChartGroupData> barGroups = [];
                String hours = "0";
                String minutes = "0";
                if (state is SleepLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek.isNotEmpty) {
                    List<int> sleepDurationInMinutes = [];
                    for (final dayEntry in dataInWeek.entries) {
                      // add day
                      dates.add(dayEntry.key);

                      // calculte sleep duration in minutes
                      int currentDayDurationInMinutes = 0;
                      for (final sleep in dayEntry.value) {
                        final fromDate = sleep.fromDate;
                        final toDate = sleep.toDate;
                        if (fromDate != null && toDate != null) {
                          final duration = toDate.difference(fromDate);

                          sleepDurationInMinutes.add(duration.inMinutes);
                          currentDayDurationInMinutes += duration.inMinutes;
                        }
                      }
                      final currentDayDuration = Duration(
                        minutes: currentDayDurationInMinutes,
                      );
                      final hours = currentDayDuration.inHours.toString();
                      final minutes = currentDayDuration.remainingMinutes;

                      // add data to chart
                      barGroups.add(
                        BarChartGroupData(
                          x: barGroups.length,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: "$hours.$minutes".toDouble(),
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

                    if (sleepDurationInMinutes.isNotEmpty) {
                      // calculate average sleep duration
                      final sleepDurationTotalInMinutes =
                          sleepDurationInMinutes.sum();
                      final averageSleepDuration = Duration(
                        minutes: sleepDurationTotalInMinutes ~/
                            sleepDurationInMinutes.length,
                      );
                      hours = averageSleepDuration.inHours.toString();
                      minutes = averageSleepDuration.remainingMinutes;
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  barGroups: barGroups,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final toYHour = rod.toY.toInt();
                    final toYMin = rod.toY.toString().split(".")[1];
                    final date = dates[group.x.toInt()];

                    return BarTooltipItem(
                      textAlign: TextAlign.start,
                      toYHour.toString(),
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
                          text: toYMin,
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
                  averageWidget: Row(
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
            OptionsButtonWidget(
              items: [
                OptionButtonItem(
                  label: context.locale.showAllData,
                  onTap: _onShowAllData,
                ),
                OptionButtonItem(
                  label: context.locale.dataSourceAndAccess,
                  onTap: _onDataSourceAndAccess,
                ),
              ],
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onShowAllData() {
    // go to show all data page
    context.goNamed(AppRoute.allSleepData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
