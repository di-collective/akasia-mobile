import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class WeeklyChartWidget extends StatelessWidget {
  final List<DateTime> dates;
  final List<double> dataInWeek;
  final String unit;

  const WeeklyChartWidget({
    super.key,
    required this.dates,
    required this.unit,
    required this.dataInWeek,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    // days
    final days = dates.map((e) {
      return e.formatDate(format: 'E') ?? '';
    }).toList();

    // average
    final total = dataInWeek.fold<double>(
      0,
      (previousValue, element) {
        return previousValue + element;
      },
    );
    final average = total ~/ dataInWeek.length;

    // date range
    DateTime? firstDate;
    DateTime? endDate;
    String formattedDateRange = '';
    if (dataInWeek.isNotEmpty) {
      firstDate = dates.first;
      endDate = dates.last;
    }
    if (firstDate != null && endDate != null) {
      formattedDateRange = firstDate.formmatDateRange(
        endDate: endDate,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
              ),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => colorScheme.outlineBright,
                      tooltipRoundedRadius: 4,
                      tooltipPadding: const EdgeInsets.all(4),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final date = dates[group.x.toInt()];

                        return BarTooltipItem(
                          textAlign: TextAlign.start,
                          rod.toY.toInt().formatNumber(
                                locale: AppLocale.id.locale.countryCode,
                              ),
                          textTheme.titleMedium.copyWith(
                            color: colorScheme.onSurfaceDim,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: ' $unit',
                              style: textTheme.bodySmall.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\n${date.formatDate(format: 'dd MMM yyyy')}',
                              style: textTheme.bodySmall.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 15,
                        getTitlesWidget: (value, meta) {
                          final day = days[value.toInt()];

                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 2,
                            child: Text(
                              day,
                              style: textTheme.labelSmall.copyWith(
                                color: colorScheme.onSurfaceBright,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) {
                          final isFirst = value.isSame(otherValue: meta.min);
                          final lastDay =
                              dataInWeek.isNotEmpty ? dataInWeek.last : null;
                          final isMiddle =
                              value == (lastDay != null ? lastDay / 2 : 0);
                          final isLast = value.isSame(otherValue: meta.max);

                          if (isFirst || isMiddle || isLast) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 2,
                              child: Text(
                                value.toInt().formatNumber(
                                      locale: AppLocale.id.locale.countryCode,
                                    ),
                                style: textTheme.labelSmall.copyWith(
                                  color: colorScheme.onSurfaceBright,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: colorScheme.outline,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outline,
                        strokeWidth: 1,
                        dashArray: [2],
                      );
                    },
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outline,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: List.generate(
                    dataInWeek.length,
                    (index) {
                      final x = index;
                      final y = dataInWeek[index];

                      return BarChartGroupData(
                        x: x,
                        barRods: [
                          BarChartRodData(
                            toY: y,
                            color: colorScheme.primary,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                            width: 25,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.average,
                  style: textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceBright,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      average.formatNumber(
                        locale: AppLocale.id.locale.countryCode,
                      ),
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
                        unit,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  formattedDateRange,
                  style: textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceBright,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
