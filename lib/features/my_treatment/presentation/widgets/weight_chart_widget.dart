import 'dart:math';

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
import '../../../../core/ui/extensions/dynamic_extension.dart';
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
import '../cubit/weight_goal/weight_goal_cubit.dart';
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
          isDisabled: widget.isDisabled,
          onRecordWeight: _onRecordWeight,
          weights: weights,
          weightGoal: widget.weightGoal,
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

      // if date is current date, update weight on profile
      if (date.isSame(
        other: DateTime.now(),
        withoutHour: true,
        withoutMinute: true,
        withoutSecond: true,
      )) {
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
      }

      // if date is starting date, update starting weight in weight goal
      final startingDate = widget.weightGoal?.startingDate?.dynamicToDateTime;
      if (date.isSame(
        other: startingDate,
        withoutHour: true,
        withoutMinute: true,
        withoutSecond: true,
      )) {
        // update starting weight in weight goal
        await BlocProvider.of<WeightGoalCubit>(context).updateWeightGoal(
          newWeightGoal: WeightGoalEntity(
            startingWeight: newWeight,
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
  final List<WeightHistoryEntity> weights;
  final bool? isDisabled;
  final Function() onRecordWeight;
  final WeightGoalEntity? weightGoal;

  const _ChartWidget({
    required this.isDisabled,
    required this.onRecordWeight,
    required this.weights,
    required this.weightGoal,
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
    double? minY;
    double? maxY;
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
        final weight = e.weight ?? 0;

        // get min and max x
        if (minY == null || maxY == null) {
          minY = weight;
          maxY = weight;
        } else {
          minY = min(minY!, weight);
          maxY = max(maxY!, weight);
        }

        return weight;
      }).toList();

      // reverse the list
      weights = weights.reversed.toList();
    }

    // calculate min and max x
    final flag = widget.weightGoal?.flag;
    final targetWeight = widget.weightGoal?.targetWeight;
    if (flag != null) {
      switch (flag) {
        case WeightGoalFlag.loss:
          // set target weight as min x
          minY = min(minY!, targetWeight ?? 0);

          break;
        case WeightGoalFlag.gain:
        case WeightGoalFlag.maintain:
          // set target weight as max x
          maxY = max(maxY!, targetWeight ?? 0);

          break;
      }
    }

    // add target weight to the weights
    bool isCompleted = true;
    final targetDate = widget.weightGoal?.targetDate?.dynamicToDateTime;
    if (lastDate != null && targetDate != null) {
      if (lastDate.isBefore(targetDate)) {
        // add target weight
        weights.add(targetWeight ?? 0);
        isCompleted = false;
      }
    }

    firstWeight ??= 0;
    lastWeight ??= 0;

    final differenceWeight = firstWeight - lastWeight;
    final isGainWeight = differenceWeight < 0;
    String? arrowIconPath;
    Color? arrowIconColor;
    if (differenceWeight != 0) {
      arrowIconPath =
          isGainWeight ? AssetIconsPath.icArrowUp : AssetIconsPath.icArrowDown;
      arrowIconColor =
          isGainWeight ? colorScheme.onSurfaceDim : colorScheme.success;
    }

    final List<FlSpot> spotsWithoutTargetWeight = [];
    final List<FlSpot> spotsOnlyTargetWeight = [];
    for (int i = 0; i < weights.length; i++) {
      final isTwoLast = i == weights.length - 2;
      final isLast = i == weights.length - 1;

      if ((isTwoLast || isLast) && !isCompleted) {
        spotsOnlyTargetWeight.add(FlSpot(
          i.toDouble(),
          weights[i],
        ));
      }

      if (!isLast) {
        spotsWithoutTargetWeight.add(FlSpot(
          i.toDouble(),
          weights[i],
        ));
      }
    }

    final lineBarsData = [
      if (spotsOnlyTargetWeight.isNotEmpty) ...[
        LineChartBarData(
          show: true,
          spots: spotsOnlyTargetWeight,
          barWidth: 2,
          color: colorScheme.outlineDim,
          dashArray: [5, 5],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                strokeColor: colorScheme.white,
                strokeWidth: 1,
                color: colorScheme.outlineDim,
              );
            },
          ),
        ),
      ],
      LineChartBarData(
        show: true,
        spots: spotsWithoutTargetWeight,
        barWidth: 2,
        color: colorScheme.onSurfaceDim,
        dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) {
            // first dot
            if (spot.x.isSame(
              otherValue: 0,
            )) {
              return true;
            }

            // last dot
            if (spot.x.isSame(
              otherValue: spotsWithoutTargetWeight.length - 1,
            )) {
              return true;
            }

            return false;
          },
          getDotPainter: (spot, percent, barData, index) {
            final isLast = spot.x.isSame(
              otherValue: spotsWithoutTargetWeight.length - 1,
            );

            return FlDotCirclePainter(
              radius: 4,
              strokeColor: colorScheme.white,
              strokeWidth: 1,
              color: isLast ? colorScheme.error : colorScheme.onSurfaceDim,
            );
          },
        ),
      ),
    ];

    LineChartBarData? tooltipsOnBar;
    if (lineBarsData.isNotEmpty) {
      tooltipsOnBar = lineBarsData.last;
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
                      if (arrowIconPath != null && arrowIconColor != null) ...[
                        SvgPicture.asset(
                          arrowIconPath,
                          colorFilter: ColorFilter.mode(
                            arrowIconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: differenceWeight.parseToString(
                                isRemoveMinus: true,
                                maxFractionDigits: 2,
                              ),
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
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: lineBarsData,
                  lineTouchData: LineTouchData(
                    enabled: false,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) {
                        final isLast = touchedSpot.x.isSame(
                          otherValue: spotsWithoutTargetWeight.length - 1,
                        );
                        if (isLast) {
                          return colorScheme.error;
                        }

                        return colorScheme.onSurfaceDim;
                      },
                      tooltipRoundedRadius: 4,
                      tooltipPadding: const EdgeInsets.all(4),
                      tooltipMargin: 6,
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map(
                          (lineBarSpot) {
                            return LineTooltipItem(
                              lineBarSpot.y.parseToString(),
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
                        reservedSize: 30,
                        getTitlesWidget: (value, axisSide) {
                          final isTargetWeight = value.isSame(
                            otherValue: targetWeight,
                          );

                          return SideTitleWidget(
                            axisSide: AxisSide.right,
                            child: Text(
                              value.parseToString(),
                              style: textTheme.labelSmall.copyWith(
                                fontWeight: isTargetWeight
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: colorScheme.onSurfaceBright,
                                fontSize: isTargetWeight ? 12 : 10,
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
                            weightsWithoutTargetWeightLength:
                                spotsWithoutTargetWeight.length,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            isCompleted: isCompleted,
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
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  showingTooltipIndicators:
                      spotsWithoutTargetWeight.asMap().entries.map(
                    (entry) {
                      final index = entry.key;

                      final isLast =
                          index == spotsWithoutTargetWeight.length - 1;
                      return ShowingTooltipIndicators(
                        [
                          if (tooltipsOnBar != null &&
                              (index == 0 || isLast)) ...[
                            LineBarSpot(
                              tooltipsOnBar,
                              lineBarsData.indexOf(tooltipsOnBar),
                              tooltipsOnBar.spots[index],
                            ),
                          ],
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
                        text: lastWeight.parseToString(),
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
                isDisabled: widget.isDisabled,
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
    required int weightsWithoutTargetWeightLength,
    required DateTime? firstDate,
    required DateTime? lastDate,
    required bool isCompleted,
  }) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    String? text;
    if (value.isSame(otherValue: 0)) {
      text = firstDate?.formatDate(
        format: 'dd MMM',
      );
    } else if (value.isSame(otherValue: weightsWithoutTargetWeightLength - 1)) {
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
