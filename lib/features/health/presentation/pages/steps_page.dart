import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../cubit/steps/steps_cubit.dart';
import '../widgets/option_button_item_widget.dart';
import '../widgets/weekly_chart_widget.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.steps,
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
            BlocBuilder<StepsCubit, StepsState>(
              builder: (context, state) {
                List<double> data = [];
                List<DateTime> dates = [];
                if (state is StepsLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek != null && dataInWeek.isNotEmpty) {
                    data = dataInWeek.map((e) {
                      return e.count?.toDouble() ?? 0;
                    }).toList();

                    dates = dataInWeek.map((e) {
                      return e.date ?? DateTime.now();
                    }).toList();
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  dataInWeek: data,
                  unit: context.locale.stepsUnit,
                  barGroups: List.generate(
                    data.length,
                    (index) {
                      final x = index;
                      final y = data[index];

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
                  getTitlesWidget: (value, meta) {
                    final isFirst = value.isSame(otherValue: meta.min);
                    final lastDay = data.isNotEmpty ? data.last : null;
                    final isMiddle = value ==
                        (lastDay != null ? lastDay / 2 : 0); // TODO: Fix this
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
    // go to show all data page
    context.goNamed(AppRoute.allStepsData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
