import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../cubit/nutrition/nutrition_cubit.dart';
import '../widgets/actvity_item_loading_widget.dart';
import 'sleep_details_page.dart';

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
          // if (state is NutritionLoaded) {
          // final nutritions = state.nutritions?.data;
          // if (nutritions == null || nutritions.isEmpty) {
          //   return const StateEmptyWidget();
          // }

          // Map<DateTime, List<SleepActivityEntity>> sortedSleeps = {};
          // for (int i = nutritions.length - 1; i > 0; i--) {
          //   final sleep = nutritions[i];

          //   final fromDate = sleep.fromDate;
          //   if (fromDate == null) {
          //     continue;
          //   }

          //   final data = nutritions.where((element) {
          //     return element.fromDate?.isSameDay(other: fromDate) ?? false;
          //   });

          //   sortedSleeps.addAll({
          //     fromDate.firstHourOfDay: data.toList(),
          //   });
          // }

          //   return ListView.separated(
          //     itemCount: sortedSleeps.keys.length,
          //     primary: false,
          //     shrinkWrap: true,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: context.paddingHorizontal,
          //       vertical: 16,
          //     ),
          //     separatorBuilder: (context, index) {
          //       return const Divider();
          //     },
          //     itemBuilder: (context, index) {
          //       final sleep = sortedSleeps.entries.toList()[index];

          //       // date range
          //       DateTime? fromDate;
          //       DateTime? toDate;
          //       String formattedDateRange = '';
          //       Duration totalDuration = const Duration();

          //       for (final item in sleep.value) {
          //         final currentFromDate = item.fromDate;
          //         final currentToDate = item.toDate;
          //         if (currentFromDate == null || currentToDate == null) {
          //           continue;
          //         }

          //         if (fromDate == null || currentFromDate.isBefore(fromDate)) {
          //           fromDate = currentFromDate;
          //         }

          //         if (toDate == null || currentToDate.isAfter(toDate)) {
          //           toDate = currentToDate;
          //         }

          //         final duration = currentToDate.difference(currentFromDate);

          //         totalDuration += duration;
          //       }

          //       final formattedTotalDuration =
          //           "${totalDuration.inHours}hrs ${totalDuration.remainingMinutes}min";

          //       if (fromDate != null && toDate != null) {
          //         formattedDateRange = fromDate.formatDateRange(
          //           endDate: toDate,
          //           formatEndDate: 'dd MMM',
          //         );
          //       }

          //       return ActivityItemWidget(
          //         isFirst: index == 0,
          //         isLast: index == sortedSleeps.keys.length - 1,
          //         title: formattedDateRange,
          //         value:
          //             "${sleep.value.length} interval ($formattedTotalDuration)",
          //         onTap: () {
          //           _onNutrition(
          //             params: SleepDetailsPageParams(
          //               sleeps: sleep.value,
          //               formattedDateRange: formattedDateRange,
          //               totalDuration: totalDuration,
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   );
          // } else if (state is NutritionError) {
          //   return StateErrorWidget(
          //     description: state.error.message(context),
          //   );
          // }

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
    required SleepDetailsPageParams params,
  }) {
    context.goNamed(
      AppRoute.sleepDetails.name,
      extra: params,
    );
  }
}
