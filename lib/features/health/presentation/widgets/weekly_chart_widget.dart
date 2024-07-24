import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class WeeklyChartWidget extends StatefulWidget {
  final List<DateTime> dates;
  final String? unit;
  final Widget? unitWidget;
  final String? averageLabel;
  final Widget? averageWidget;
  final String? average;
  final List<BarChartGroupData> barGroups;
  final String? Function(BarChartGroupData, int, BarChartRodData, int)?
      tooltipTextValue;
  final BarTooltipItem? Function(BarChartGroupData, int, BarChartRodData, int)?
      getTooltipItem;

  const WeeklyChartWidget({
    super.key,
    required this.dates,
    this.unit,
    this.unitWidget,
    this.averageLabel,
    this.average,
    this.averageWidget,
    required this.barGroups,
    this.tooltipTextValue,
    this.getTooltipItem,
  });

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    // days
    final days = widget.dates.map((e) {
      return e.formatDate(format: 'E') ?? '';
    }).toList();

    // date range
    DateTime? firstDate;
    DateTime? endDate;
    String formattedDateRange = '';
    if (days.isNotEmpty) {
      firstDate = widget.dates.first;
      endDate = widget.dates.last;
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      getTooltipItem: _getTooltipItem,
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
                  barGroups: widget.barGroups,
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
                  widget.averageLabel ?? context.locale.average,
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
                    if (widget.averageWidget != null) ...[
                      widget.averageWidget!,
                    ] else if (widget.average != null) ...[
                      Text(
                        widget.average!,
                        style: textTheme.headlineLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(
                      width: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 6,
                      ),
                      child: _unitWidget,
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

  BarTooltipItem? _getTooltipItem(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    if (widget.getTooltipItem != null) {
      return widget.getTooltipItem!(
        group,
        groupIndex,
        rod,
        rodIndex,
      );
    }

    if (widget.tooltipTextValue != null) {
      final textTheme = context.theme.appTextTheme;
      final colorScheme = context.theme.appColorScheme;

      final date = widget.dates[group.x.toInt()];

      return BarTooltipItem(
        textAlign: TextAlign.start,
        widget.tooltipTextValue!(
          group,
          groupIndex,
          rod,
          rodIndex,
        )!,
        textTheme.titleMedium.copyWith(
          color: colorScheme.onSurfaceDim,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: ' ${widget.unit}',
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
    }

    return null;
  }

  Widget? get _unitWidget {
    if (widget.unitWidget != null) {
      return widget.unitWidget!;
    }

    if (widget.unit != null) {
      final textTheme = context.theme.appTextTheme;
      final colorScheme = context.theme.appColorScheme;

      return Text(
        widget.unit ?? '',
        style: textTheme.bodySmall.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    }

    return null;
  }
}
