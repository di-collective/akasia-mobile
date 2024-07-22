import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../domain/entities/sleep_activity_entity.dart';
import '../cubit/sleep/sleep_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';

class AllSleepDataPage extends StatefulWidget {
  const AllSleepDataPage({super.key});

  @override
  State<AllSleepDataPage> createState() => _AllSleepDataPageState();
}

class _AllSleepDataPageState extends State<AllSleepDataPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetSleepsAll();
  }

  Future<void> _onGetSleepsAll() async {
    await BlocProvider.of<SleepCubit>(context).getSleepAll();
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
      body: BlocBuilder<SleepCubit, SleepState>(
        builder: (context, state) {
          if (state is SleepLoaded) {
            final sleeps = state.sleep?.data;
            if (sleeps == null || sleeps.isEmpty) {
              return const StateEmptyWidget();
            }

            Map<DateTime, List<SleepActivityEntity>> sortedSleeps = {};
            for (int i = 0; i < sleeps.length; i++) {
              final sleep = sleeps[i];

              final fromDate = sleep.fromDate;
              if (fromDate == null) {
                continue;
              }

              final data = sleeps.where((element) {
                return element.fromDate?.isSameDay(other: fromDate) ?? false;
              });

              sortedSleeps.addAll({
                fromDate: data.toList(),
              });
            }

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
                vertical: 16,
              ),
              child: ListView.separated(
                itemCount: sortedSleeps.keys.length,
                primary: false,
                shrinkWrap: true,
                reverse: true,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final sleep = sortedSleeps.entries.toList()[index];

                  // date range
                  DateTime? fromDate;
                  DateTime? toDate;
                  String formattedDateRange = '';
                  Duration totalDuration = const Duration();

                  for (final item in sleep.value) {
                    final currentFromDate = item.fromDate;
                    final currentToDate = item.toDate;
                    if (currentFromDate == null || currentToDate == null) {
                      continue;
                    }

                    if (fromDate == null ||
                        currentFromDate.isBefore(fromDate)) {
                      fromDate = currentFromDate;
                    }

                    if (toDate == null || currentToDate.isAfter(toDate)) {
                      toDate = currentToDate;
                    }

                    final duration = currentToDate.difference(currentFromDate);

                    totalDuration += duration;
                  }

                  if (fromDate != null && toDate != null) {
                    formattedDateRange = fromDate.formmatDateRange(
                      endDate: toDate,
                    );
                  }

                  return ActivityItemWidget(
                    isLast: index == 0,
                    isFirst: index == sortedSleeps.keys.length - 1,
                    title: formattedDateRange,
                    value:
                        "${sleep.value.length} interval (${totalDuration.inHours}h ${totalDuration.remainingMinutes}m)",
                    onTap: () {},
                  );
                },
              ),
            );
          } else if (state is SleepError) {
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
}
