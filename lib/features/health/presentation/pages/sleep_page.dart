import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../cubit/sleep/sleep_cubit.dart';
import '../widgets/option_button_item_widget.dart';
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
                List<double> data = [];
                List<DateTime> dates = [];
                String hours = "0";
                String minutes = "0";
                List<BarChartGroupData> barGroups = [];
                if (state is SleepLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek.isNotEmpty) {
                    // data = dataInWeek.map((e) {
                    //   return e.count?.toDouble() ?? 0;
                    // }).toList();

                    int sleepDurationInMinutes = 0;

                    dates = dataInWeek.keys.map((e) {
                      return e;
                    }).toList();

                    for (final day in dataInWeek.values) {
                      int currentDayDurationInMinutes = 0;

                      for (final sleep in day) {
                        final fromDate = sleep.fromDate;
                        final toDate = sleep.toDate;
                        if (fromDate != null && toDate != null) {
                          final duration = toDate.difference(fromDate);
                          sleepDurationInMinutes += duration.inMinutes;

                          currentDayDurationInMinutes += duration.inMinutes;
                        }
                      }

                      final currentDayDuration = Duration(
                        minutes: currentDayDurationInMinutes,
                      );
                      final hours = currentDayDuration.inHours.toString();
                      final minutes = currentDayDuration.remainingMinutes;

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

                    if (dataInWeek.isNotEmpty) {
                      final averageSleepDuration = Duration(
                        minutes: sleepDurationInMinutes ~/ dataInWeek.length,
                      );
                      hours = averageSleepDuration.inHours.toString();
                      minutes = averageSleepDuration.remainingMinutes;
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  dataInWeek: data,
                  barGroups: barGroups,
                  tooltipTextWidget: (group, groupIndex, rod, rodIndex) {
                    return [
                      TextSpan(
                        text: 'h ',
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurfaceBright,
                        ),
                      ),
                      TextSpan(
                        text: rod.toY.toString().split(".")[1],
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
                    ];
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
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 2,
                      child: Text(
                        value.toString(),
                        style: textTheme.labelSmall.copyWith(
                          color: colorScheme.onSurfaceBright,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
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

  void _onShowAllData() {
    // go to show all sleep data page
    context.goNamed(AppRoute.allSleepData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
