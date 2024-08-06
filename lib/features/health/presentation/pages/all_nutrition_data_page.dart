import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../domain/entities/nutrition_activity_entity.dart';
import '../cubit/nutrition/nutrition_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';
import 'nutrition_details_page.dart';

class AllNutritionDataPage extends StatefulWidget {
  const AllNutritionDataPage({super.key});

  @override
  State<AllNutritionDataPage> createState() => _AllNutritionDataPageState();
}

class _AllNutritionDataPageState extends State<AllNutritionDataPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetNutritionAll();
  }

  Future<void> _onGetNutritionAll() async {
    await BlocProvider.of<NutritionCubit>(context).getNutritionAll();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.allData,
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: BlocBuilder<NutritionCubit, NutritionState>(
        builder: (context, state) {
          if (state is NutritionLoaded) {
            final nutritions = state.nutritions?.data;
            if (nutritions == null || nutritions.isEmpty) {
              return StateEmptyWidget(
                width: context.width,
              );
            }

            Map<DateTime, List<NutritionActivityEntity>> sortedNutritions = {};
            for (int i = nutritions.length - 1; i >= 0; i--) {
              final nutrition = nutritions[i];
              final fromDate = nutrition.fromDate;

              if (fromDate == null) {
                continue;
              }

              final key = fromDate.firstHourOfDay;
              if (sortedNutritions.containsKey(key)) {
                sortedNutritions[key]!.add(nutrition);
              } else {
                sortedNutritions[key] = [nutrition];
              }
            }

            return ListView.separated(
              itemCount: sortedNutritions.keys.length,
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
                vertical: 16,
              ),
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                final nutritions = sortedNutritions.entries.toList()[index];

                final date = nutritions.key;
                final formattedDate = date.formatDate(
                  format: 'dd MMM',
                );

                double nutritionsInDay = 0;
                for (final item in nutritions.value) {
                  final value = item.value;
                  if (value == null) {
                    continue;
                  }

                  nutritionsInDay += value;
                }

                return ActivityItemWidget(
                  isFirst: index == 0,
                  isLast: index == sortedNutritions.keys.length - 1,
                  title: formattedDate ?? "",
                  value: "${nutritionsInDay}cal",
                  onTap: () {
                    _onNutrition(
                      params: NutritionDetailsPageParams(
                        items: nutritions.value,
                        nutritionsInDay: nutritionsInDay,
                        date: date,
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is NutritionError) {
            return StateErrorWidget(
              description: state.error.message(context),
            );
          }

          return ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return const ActivityItemLoadingWidget();
            },
          );
        },
      ),
    );
  }

  void _onNutrition({
    required NutritionDetailsPageParams params,
  }) {
    context.goNamed(
      AppRoute.nutritionDetails.name,
      extra: params,
    );
  }
}
