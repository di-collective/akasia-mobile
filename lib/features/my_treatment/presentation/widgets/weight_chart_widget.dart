import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import '../../../../core/ui/theme/text_theme.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dialogs/bottom_sheet_info.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/weight_history/weight_history_cubit.dart';
import 'record_weight_body_widget.dart';

class WeightChartWidget extends StatefulWidget {
  final bool? isDisabled;

  const WeightChartWidget({
    super.key,
    this.isDisabled,
  });

  @override
  State<WeightChartWidget> createState() => _WeightChartWidgetState();
}

class _WeightChartWidgetState extends State<WeightChartWidget> {
  double _firstWeight = 0;
  double _currentWeight = 0;
  double _targetWeight = 0;
  double _minimumWeight = 0;
  double _firstDate = 0;
  double _currentDate = 0;
  double _maxDate = 0;
  List<LineChartBarData> _lineBarsData = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    if (widget.isDisabled != true) {
      _firstWeight = 52;
      _currentWeight = 50;
      _targetWeight = 47.2;
      _minimumWeight = _targetWeight - 1;
      _firstDate = 1;
      _currentDate = 3;
      _maxDate = 10;

      _lineBarsData = [
        LineChartBarData(
          spots: [
            FlSpot(
              _firstDate,
              _firstWeight,
            ),
            FlSpot(
              _currentDate,
              _currentWeight,
            ),
          ],
          barWidth: 2,
          color: colorScheme.onSurfaceDim,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              return spot.y != _targetWeight;
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: spot.y == _currentWeight
                    ? colorScheme.error
                    : colorScheme.onSurfaceDim,
              );
            },
          ),
        ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Lose 3/4 kg per week",
                style: textTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceDim,
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: _onEditWeight,
              child: Text(
                context.locale.edit,
                style: textTheme.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      context.locale.workouts,
                      style: textTheme.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _weightChanges(
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 232,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: LineChart(
                    LineChartData(
                      minX: _firstDate,
                      maxX: _maxDate,
                      minY: _minimumWeight,
                      maxY: _firstWeight,
                      lineBarsData: _lineBarsData,
                      lineTouchData: LineTouchData(
                        enabled: false,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) {
                            if (touchedSpot.y == _currentWeight) {
                              return colorScheme.error;
                            }

                            return colorScheme.onSurfaceDim;
                          },
                          tooltipRoundedRadius: 2,
                          tooltipPadding: const EdgeInsets.all(4),
                          tooltipMargin: 10,
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map(
                              (lineBarSpot) {
                                return LineTooltipItem(
                                  lineBarSpot.y.parseToString,
                                  textTheme.bodySmall.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, axisSide) {
                              return SideTitleWidget(
                                axisSide: AxisSide.right,
                                child: Text(
                                  value.parseToString,
                                  style: textTheme.labelSmall.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurfaceBright,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: colorScheme.outline,
                            strokeWidth: 0.5,
                          );
                        },
                        horizontalInterval: 1,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      showingTooltipIndicators: [
                        _firstWeight.toInt(),
                        _currentWeight.toInt(),
                      ].map(
                        (weight) {
                          return ShowingTooltipIndicators(
                            [
                              LineBarSpot(
                                _lineBarsData.first,
                                _lineBarsData.indexOf(_lineBarsData.first),
                                _lineBarsData.first.spots.firstWhere(
                                  (element) {
                                    return element.y == weight;
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                date,
                style: textTheme.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceBright,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: weight,
                            style: textTheme.headlineLarge.copyWith(
                              color: colorScheme.onSurfaceDim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: " kgs",
                            style: textTheme.bodySmall.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 3,
                    ),
                  ),
                  ButtonWidget(
                    text: context.locale.recordWeight.toCapitalizes(),
                    onTap: _onRecordWeight,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get date {
    if (widget.isDisabled == true) {
      return "*${context.locale.byItem(
        context.locale.date,
      )}*";
    }

    return "23 Feb";
  }

  String get weight {
    if (widget.isDisabled == true) {
      return "-";
    }

    return "90";
  }

  Widget _weightChanges({
    required AppTextTheme textTheme,
    required AppColorScheme colorScheme,
  }) {
    if (widget.isDisabled == true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AssetIconsPath.icArrowDown,
            ),
            const SizedBox(
              width: 4,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: (_firstWeight - _currentWeight).parseToString,
                    style: TextStyle(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " kgs",
                    style: TextStyle(
                      color: colorScheme.onSurfaceBright,
                    ),
                  ),
                ],
                style: textTheme.bodySmall.copyWith(
                  color: colorScheme.onSurfaceBright,
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "since 23 feb",
          style: textTheme.bodySmall.copyWith(
            color: colorScheme.onSurfaceBright,
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    String? text;
    if (value == 1) {
      text = "23 Feb";
    } else if (value == 5) {
      text = "28 Feb";
    } else if (value == _maxDate) {
      text = "1 Mar";
    }

    Widget? child;
    if (text != null) {
      child = Text(
        text,
        style: textTheme.labelSmall.copyWith(
          color: colorScheme.onSurfaceBright,
        ),
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: child ?? const SizedBox.shrink(),
    );
  }

  void _onEditWeight() {
    // TODO: implement _onEditWeight
  }

  Future<void> _onRecordWeight() async {
    try {
      // show confirmation dialog
      final isSuccess = await sl<BottomSheetInfo>().showMaterialModal(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsetsBottom,
            ),
            child: RecordWeightBodyWidget(
              onCancel: () {
                Navigator.of(context).pop(false);
              },
              onSave: (value, date) async {
                final isSuccess = await _onSaveWeight(
                  value: value,
                  date: date,
                );
                if (isSuccess != true) {
                  return;
                }

                // close dialog
                Navigator.of(context).pop(isSuccess);
              },
            ),
          );
        },
      );
      if (isSuccess != true) {
        return;
      }

      // close this page
      context.pop();
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }

  Future<bool?> _onSaveWeight({
    required String value,
    required DateTime date,
  }) async {
    try {
      // show loading
      context.showFullScreenLoading();

      // update weight
      final weight = value.toDouble();
      await BlocProvider.of<WeightHistoryCubit>(context).updateWeight(
        weight: weight,
        date: date,
      );

      // show success message
      context.showSuccessToast(
        message: context.locale.successItem(
          context.locale.addItem(
            context.locale.weight,
          ),
        ),
      );

      return true;
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return false;
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }
}
