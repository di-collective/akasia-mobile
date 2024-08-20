import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/options_button_widget.dart';
import '../cubit/steps/steps_cubit.dart';
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
                final List<DateTime> dates = [];
                final List<BarChartGroupData> barGroups = [];
                int average = 0;
                if (state is StepsLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek != null && dataInWeek.isNotEmpty) {
                    List<int> stepsTotal = [];
                    for (final value in dataInWeek) {
                      final date = value.date;
                      final count = value.count;

                      // add date
                      dates.add(date ?? DateTime.now());

                      // add data to chart
                      barGroups.add(
                        BarChartGroupData(
                          x: barGroups.length,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: (count ?? 0).toDouble(),
                              color: colorScheme.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              width: 25,
                            ),
                          ],
                        ),
                      );

                      if (count != null) {
                        // add for counting average
                        stepsTotal.add(count);
                      }
                    }

                    // calculate average
                    final total = stepsTotal.sum();
                    if (stepsTotal.isNotEmpty) {
                      average = total ~/ stepsTotal.length;
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  unit: context.locale.stepsUnit,
                  average: average.formatNumber(
                    locale: AppLocale.id.locale.countryCode,
                  ),
                  barGroups: barGroups,
                  tooltipTextValue: (group, groupIndex, rod, rodInde) {
                    final toY = rod.toY.toInt();

                    return toY.formatNumber(
                      locale: AppLocale.id.locale.countryCode,
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
    context.goNamed(AppRoute.allStepsData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
