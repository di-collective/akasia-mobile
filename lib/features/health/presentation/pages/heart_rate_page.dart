import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/options_button_widget.dart';
import '../cubit/heart_rate/heart_rate_cubit.dart';
import '../widgets/weekly_chart_widget.dart';

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});

  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.heartRate,
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
            BlocBuilder<HeartRateCubit, HeartRateState>(
              builder: (context, state) {
                final List<DateTime> dates = [];
                final List<BarChartGroupData> barGroups = [];
                int minHeartRate = 0;
                int maxHeartRate = 0;
                if (state is HeartRateLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek.isNotEmpty) {
                    for (final dayEntry in dataInWeek.entries) {
                      // add day
                      dates.add(dayEntry.key);

                      int? currentMinHeartRate;
                      int? currentMaxHeartRate;

                      // get min and max heart rate
                      for (final heartRate in dayEntry.value) {
                        final value = heartRate.value;
                        if (value == null) {
                          continue;
                        }

                        // min
                        if (currentMinHeartRate == null) {
                          currentMinHeartRate = value;
                        } else if (value < currentMinHeartRate) {
                          currentMinHeartRate = value;
                        }

                        // max
                        if (currentMaxHeartRate == null) {
                          currentMaxHeartRate = value;
                        } else if (value > currentMaxHeartRate) {
                          currentMaxHeartRate = value;
                        }
                      }

                      // set min and max heart rate for the week
                      if (currentMinHeartRate != null &&
                          currentMinHeartRate < minHeartRate) {
                        minHeartRate = currentMinHeartRate;
                      }
                      if (currentMaxHeartRate != null &&
                          currentMaxHeartRate > maxHeartRate) {
                        maxHeartRate = currentMaxHeartRate;
                      }

                      currentMinHeartRate ??= 0;
                      currentMaxHeartRate ??= 0;

                      // add data to chart
                      barGroups.add(
                        BarChartGroupData(
                          x: barGroups.length,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: currentMaxHeartRate.toDouble(),
                              fromY: currentMinHeartRate.toDouble(),
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(3),
                              width: 25,
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  barGroups: barGroups,
                  averageLabel: context.locale.range,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final fromY = rod.fromY.toInt();
                    final toY = rod.toY.toInt();
                    final date = dates[group.x.toInt()];

                    return BarTooltipItem(
                      textAlign: TextAlign.start,
                      fromY.toString(),
                      textTheme.titleMedium.copyWith(
                        color: colorScheme.onSurfaceDim,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: "-$toY ",
                          style: textTheme.titleMedium.copyWith(
                            color: colorScheme.onSurfaceDim,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: context.locale.heartRateUnit,
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
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
                        "$minHeartRate-$maxHeartRate",
                        style: textTheme.headlineLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  unitWidget: Column(
                    children: [
                      SvgPicture.asset(
                        AssetIconsPath.icLove,
                        colorFilter: ColorFilter.mode(
                          colorScheme.error,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        context.locale.heartRateUnit,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurface,
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
    context.goNamed(AppRoute.allHeartRateData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
