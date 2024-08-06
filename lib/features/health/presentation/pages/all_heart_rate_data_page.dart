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
import '../../domain/entities/heart_rate_activity_entity.dart';
import '../cubit/heart_rate/heart_rate_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';
import 'heart_rate_details_page.dart';

class AllHeartRateDataPage extends StatefulWidget {
  const AllHeartRateDataPage({super.key});

  @override
  State<AllHeartRateDataPage> createState() => _AllHeartRateDataPageState();
}

class _AllHeartRateDataPageState extends State<AllHeartRateDataPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetHearRateAll();
  }

  Future<void> _onGetHearRateAll() async {
    await BlocProvider.of<HeartRateCubit>(context).getHeartRateAll();
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
      body: BlocBuilder<HeartRateCubit, HeartRateState>(
        builder: (context, state) {
          if (state is HeartRateLoaded) {
            final items = state.heartRate?.data;
            if (items == null || items.isEmpty) {
              return StateEmptyWidget(
                width: context.width,
              );
            }

            Map<DateTime, List<HeartRateActivityEntity>> tempSortedItems = {};
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
                return b
                    .compareTo(a); // This sorts the dates in descending order
              });

            // Rebuild the sortedItems map with sorted keys
            Map<DateTime, List<HeartRateActivityEntity>> sortedItems = {
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
                final item = sortedItems.entries.toList()[index];

                // date
                final date = item.key.formatDate(
                  format: 'dd MMMM',
                );

                // calculate min and max heart rate
                int? minHeartRate;
                int? maxHeartRate;
                for (final heartRate in item.value) {
                  final value = heartRate.value;
                  if (value == null) {
                    continue;
                  }

                  // min
                  if (minHeartRate == null) {
                    minHeartRate = value;
                  } else if (value < minHeartRate) {
                    minHeartRate = value;
                  }

                  // max
                  if (maxHeartRate == null) {
                    maxHeartRate = value;
                  } else if (value > maxHeartRate) {
                    maxHeartRate = value;
                  }
                }

                minHeartRate ??= 0;
                maxHeartRate ??= 0;

                final totalRange = '$minHeartRate-$maxHeartRate';

                return ActivityItemWidget(
                  isFirst: index == 0,
                  isLast: index == sortedItems.keys.length - 1,
                  title: date ?? '',
                  value: totalRange,
                  onTap: () {
                    _onHeartRate(
                      params: HeartRateDetailsPageParams(
                        items: item.value,
                        totalRange: totalRange,
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is HeartRateError) {
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

  void _onHeartRate({
    required HeartRateDetailsPageParams params,
  }) {
    context.goNamed(
      AppRoute.heartRateDetails.name,
      extra: params,
    );
  }
}
