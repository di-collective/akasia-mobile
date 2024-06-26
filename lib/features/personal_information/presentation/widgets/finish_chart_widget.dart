import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class FinishChartWidget extends StatefulWidget {
  const FinishChartWidget({super.key});

  @override
  State<FinishChartWidget> createState() => _FinishChartWidgetState();
}

class _FinishChartWidgetState extends State<FinishChartWidget> {
  final List<Color> gradientColors = [
    const Color(0xFFF93D3D),
    const Color(0xFFF37021),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineTouchData: const LineTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: bottomTitleWidgets,
              reservedSize: 30,
            ),
          ),
        ),
        gridData: const FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 6),
              FlSpot(1.5, 5.95),
              FlSpot(3, 5.2),
              FlSpot(7.5, 2.28),
              FlSpot(9.2, 1.8),
              FlSpot(11, 1.77),
            ],
            isCurved: true,
            barWidth: 5,
            isStrokeCapRound: true,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            curveSmoothness: 0.2,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                return spot.y == 5.95 || spot.y == 1.8;
              },
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 8,
                  color:
                      spot.x == 1.5 ? colorScheme.error : colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((color) {
                  return color.withOpacity(
                    0.15,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          verticalLines: <VerticalLine>[
            VerticalLine(
              x: 1.5,
              color: colorScheme.error,
              dashArray: [4, 4],
            ),
            VerticalLine(
              x: 9.2,
              color: colorScheme.primary,
              dashArray: [4, 4],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    Widget? text;
    if (value == 2) {
      text = Text(
        'Today',
        style: textTheme.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    } else if (value == 9) {
      text = Text(
        "April 9",
        style: textTheme.bodyLarge.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text ?? const SizedBox.shrink(),
    );
  }
}
