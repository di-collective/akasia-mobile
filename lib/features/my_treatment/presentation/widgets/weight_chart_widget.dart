import 'package:akasia365mc/core/ui/extensions/dynamic_extension.dart';
import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/weight_goal_flag_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dialogs/bottom_sheet_info.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/domain/entities/profile_entity.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../domain/entities/weight_goal_entity.dart';
import '../../domain/entities/weight_history_entity.dart';
import '../cubit/weight_history/weight_history_cubit.dart';
import 'record_weight_body_widget.dart';

class WeightChartWidget extends StatefulWidget {
  final bool? isDisabled;
  final WeightGoalEntity? weightGoal;
  final List<WeightHistoryEntity> weights;

  const WeightChartWidget({
    super.key,
    this.isDisabled,
    this.weightGoal,
    this.weights = const [],
  });

  @override
  State<WeightChartWidget> createState() => _WeightChartWidgetState();
}

class _WeightChartWidgetState extends State<WeightChartWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final weightGoal = widget.weightGoal;
    final flag = weightGoal?.flag;
    final pace = weightGoal?.pace;
    final weights = widget.weights;

    String title = "";
    if (flag != null && pace != null) {
      title = "${flag.title} ${pace.losePerWeek(
        flag: flag,
      )} per week";
    }

    double firstWeight = 0;

    double targetWeight = 0;
    double minimumWeight = 0;
    double firstDate = 0;
    double maxDate = 0;
    if (widget.isDisabled != true) {
      firstWeight = 52;
      targetWeight = 47.2;
      minimumWeight = targetWeight - 1;
      maxDate = 10;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title.toCapitalize(),
                maxLines: 2,
                style: textTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceDim,
                ),
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
        _ChartWidget(
          firstWeight: firstWeight,
          targetWeight: targetWeight,
          minimumWeight: minimumWeight,
          firstDate: firstDate,
          maxDate: maxDate,
          isDisabled: widget.isDisabled,
          onRecordWeight: _onRecordWeight,
          weights: weights,
        ),
      ],
    );
  }

  void _onEditWeight() {
    // go to edit weight goal
    context.goNamed(
      AppRoute.editWeightGoal.name,
    );
  }

  Future<void> _onRecordWeight() async {
    try {
      final startDate = widget.weightGoal?.startingDate?.dynamicToDateTime;
      final endDate = widget.weightGoal?.targetDate?.dynamicToDateTime;
      if (startDate == null || endDate == null) {
        throw "Invalid weight goal date";
      }

      // show confirmation dialog
      await sl<BottomSheetInfo>().showMaterialModal(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsetsBottom,
            ),
            child: RecordWeightBodyWidget(
              startDate: startDate,
              endDate: endDate,
              onCancel: () {
                Navigator.of(context).pop(false);
              },
              onSave: (value, date) async {
                final isSuccess = await _onSaveRecordedWeight(
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
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }

  Future<bool?> _onSaveRecordedWeight({
    required String value,
    required DateTime date,
  }) async {
    try {
      // show loading
      context.showFullScreenLoading();

      // update weight
      final newWeight = value.toDouble();
      await BlocProvider.of<WeightHistoryCubit>(context).updateWeight(
        weight: newWeight,
        date: date,
      );

      final profileState = BlocProvider.of<ProfileCubit>(context).state;
      if (profileState is ProfileLoaded) {
        // update weight on profile
        await BlocProvider.of<ProfileCubit>(context).updateProfile(
          newProfile: ProfileEntity(
            userId: profileState.profile.userId,
            weight: newWeight,
          ),
        );
      }

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

class _ChartWidget extends StatefulWidget {
  final double firstWeight;
  final double targetWeight;
  final double minimumWeight;
  final double firstDate;
  final double maxDate;
  final List<WeightHistoryEntity> weights;

  final bool? isDisabled;
  final Function() onRecordWeight;

  const _ChartWidget({
    required this.firstWeight,
    required this.targetWeight,
    required this.minimumWeight,
    required this.firstDate,
    required this.maxDate,
    required this.isDisabled,
    required this.onRecordWeight,
    required this.weights,
  });

  @override
  State<_ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<_ChartWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final weightsHistory = widget.weights;
    List<double> weights = [];
    WeightHistoryEntity? firstWeightHistory;
    WeightHistoryEntity? lastWeightHistory;
    double? firstWeight;
    DateTime? firstDate;
    double? lastWeight;
    DateTime? lastDate;
    String? fomattedStartDate;
    String? formattedLastDate;
    if (weightsHistory.isNotEmpty) {
      // get the first weight
      firstWeightHistory = weightsHistory.last;
      firstWeight = firstWeightHistory.weight;
      firstDate = firstWeightHistory.date;
      fomattedStartDate = firstWeightHistory.date?.formatDate(
        format: 'dd MMM',
      );

      // get the last weight
      lastWeightHistory = weightsHistory.first;
      lastWeight = lastWeightHistory.weight;
      lastDate = lastWeightHistory.date;
      formattedLastDate = lastDate?.formatDate(
        format: 'dd MMM',
      );

      // get all weights
      weights = weightsHistory.map((e) {
        return e.weight ?? 0;
      }).toList();
    }

    firstWeight ??= 0;
    lastWeight ??= 0;

    final differenceWeight = firstWeight - lastWeight;

    List<LineChartBarData> lineBarsData = [];
    if (widget.isDisabled != true) {
      lineBarsData = [
        LineChartBarData(
          spots: [
            FlSpot(
              0,
              firstWeight,
            ),
            // FlSpot(
            //   1,
            //   lastWeight,
            // ),
          ],
          // spots: weights.asMap().entries.map(
          //   (entry) {
          //     final index = entry.key;
          //     final weight = entry.value.weight;

          //     return FlSpot(
          //       index.toDouble(),
          //       weight ?? 0,
          //     );
          //   },
          // ).toList(),
          // barWidth: 2,
          color: colorScheme.onSurfaceDim,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              return spot.y != widget.targetWeight;
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: spot.y == lastWeight
                    ? colorScheme.error
                    : colorScheme.onSurfaceDim,
              );
            },
          ),
        ),
      ];
    }

    return Container(
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
              Column(
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
                              text: differenceWeight.parseToString,
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
                    "since ${fomattedStartDate ?? "-"}",
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurfaceBright,
                    ),
                  ),
                ],
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
                  minX: widget.firstDate,
                  maxX: widget.maxDate,
                  minY: widget.minimumWeight,
                  maxY: widget.firstWeight,
                  lineBarsData: lineBarsData,
                  lineTouchData: LineTouchData(
                    enabled: false,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) {
                        if (touchedSpot.y == lastWeight) {
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
                        getTitlesWidget: (value, meta) {
                          return bottomTitleWidgets(
                            value: value,
                            meta: meta,
                            weightsLength: weights.length,
                            firstDate: firstDate,
                            lastDate: lastDate,
                          );
                        },
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
                  // showingTooltipIndicators: weights.map(
                  //   (weight) {
                  //     return ShowingTooltipIndicators(
                  //       [
                  //         LineBarSpot(
                  //           lineBarsData.first,
                  //           lineBarsData.indexOf(lineBarsData.first),
                  //           lineBarsData.first.spots.firstWhere(
                  //             (element) {
                  //               return element.y == weight;
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            formattedLastDate ?? "-",
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
                        text: lastWeight.parseToString,
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
                onTap: widget.onRecordWeight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets({
    required double value,
    required TitleMeta meta,
    required int weightsLength,
    required DateTime? firstDate,
    required DateTime? lastDate,
  }) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    String? text;
    if (value == 0.toDouble()) {
      text = firstDate?.formatDate(
        format: 'dd MMM',
      );
    } else if (value == weightsLength.toDouble()) {
      text = lastDate?.formatDate(
        format: 'dd MMM',
      );
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
}
