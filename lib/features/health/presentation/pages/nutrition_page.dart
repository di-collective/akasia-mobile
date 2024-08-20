import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/app_locale_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/int_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/option_button_item_widget.dart';
import '../cubit/nutrition/nutrition_cubit.dart';
import '../widgets/weekly_chart_widget.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.nutritions,
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
            BlocBuilder<NutritionCubit, NutritionState>(
              builder: (context, state) {
                final List<DateTime> dates = DateTimeExtension.daysInWeek;
                final List<BarChartGroupData> barGroups = [];
                int average = 0;
                if (state is NutritionLoaded) {
                  final dataInWeek = state.getCurrentWeekData();
                  if (dataInWeek.isNotEmpty) {
                    List<double> allCalories = [];
                    for (final dayEntry in dataInWeek.entries) {
                      double calloriesInDay = 0;

                      for (final nutrition in dayEntry.value) {
                        final value = nutrition.value;

                        if (value == null) {
                          continue;
                        }

                        calloriesInDay += value;

                        // add callory
                        allCalories.add(value);
                      }

                      // add data to chart
                      barGroups.add(
                        BarChartGroupData(
                          x: barGroups.length,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: calloriesInDay,
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

                    if (allCalories.isNotEmpty) {
                      // calculate average
                      final totalCallories = allCalories.sum();
                      average = totalCallories ~/ allCalories.length;
                    }
                  }
                }

                return WeeklyChartWidget(
                  dates: dates,
                  unit: "cal",
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
    context.goNamed(AppRoute.allNutritionData.name);
  }

  void _onDataSourceAndAccess() {
    // TODO: implement _onDataSourceAndAccess
  }
}
