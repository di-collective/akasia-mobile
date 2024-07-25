import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../domain/entities/workout_activity_entity.dart';
import '../cubit/workout/workout_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';
import 'workout_details_page.dart';

class AllWorkoutDataPage extends StatefulWidget {
  const AllWorkoutDataPage({super.key});

  @override
  State<AllWorkoutDataPage> createState() => _AllWorkoutDataPageState();
}

class _AllWorkoutDataPageState extends State<AllWorkoutDataPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetWorkoutAll();
  }

  Future<void> _onGetWorkoutAll() async {
    await BlocProvider.of<WorkoutCubit>(context).getWorkoutAll();
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
      body: BlocBuilder<WorkoutCubit, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoaded) {
            final items = state.workout?.data;
            if (items == null || items.isEmpty) {
              return const StateEmptyWidget();
            }

            Map<DateTime, List<WorkoutActivityEntity>> tempSortedItems = {};
            for (var item in items) {
              final fromDate = item.fromDate;
              if (fromDate == null) {
                continue;
              }

              final dayStart = fromDate.firstHourOfDay;
              tempSortedItems.putIfAbsent(dayStart, () => []);
              tempSortedItems[dayStart]?.add(item);
            }

            // Sort the keys (dates) in reverse order
            final sortedKeys = tempSortedItems.keys.toList()
              ..sort((a, b) {
                return b.compareTo(a);
              });

            // Rebuild the sortedItems map with sorted keys
            Map<DateTime, List<WorkoutActivityEntity>> sortedItems = {
              for (var key in sortedKeys) key: tempSortedItems[key]!,
            };

            return ListView.separated(
              itemCount: sortedItems.keys.length,
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
                final workout = sortedItems.entries.toList()[index];

                // date range
                DateTime? fromDate;
                DateTime? toDate;
                Duration totalDuration = const Duration();
                for (final item in workout.value) {
                  final currentFromDate = item.fromDate;
                  final currentToDate = item.toDate;
                  if (currentFromDate == null || currentToDate == null) {
                    continue;
                  }

                  if (fromDate == null || currentFromDate.isBefore(fromDate)) {
                    fromDate = currentFromDate;
                  }

                  if (toDate == null || currentToDate.isAfter(toDate)) {
                    toDate = currentToDate;
                  }

                  final duration = currentToDate.difference(currentFromDate);

                  totalDuration += duration;
                }

                final formattedFromDate = fromDate?.formatDate(
                      format: "dd MMM yyyy",
                    ) ??
                    "";
                final formattedTotalDuration =
                    "${totalDuration.inMinutes}m ${totalDuration.remainingSeconds}s";

                return ActivityItemWidget(
                  isFirst: index == 0,
                  isLast: index == sortedItems.keys.length - 1,
                  title: formattedFromDate,
                  value: "${context.locale.workouts} ($formattedTotalDuration)",
                  onTap: () {
                    _onWorkout(
                      params: WorkoutDetailsPageParams(
                        items: workout.value,
                        totalDuration: totalDuration,
                        formattedDate: formattedFromDate,
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is WorkoutError) {
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

  void _onWorkout({
    required WorkoutDetailsPageParams params,
  }) {
    context.goNamed(
      AppRoute.workoutDetails.name,
      extra: params,
    );
  }
}
