import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../cubit/sleep/sleep_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';

class AllSleepDataPage extends StatelessWidget {
  const AllSleepDataPage({super.key});

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

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                itemCount: sleeps.length,
                primary: false,
                shrinkWrap: true,
                reverse: true,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final sleep = sleeps[index];

                  // date range
                  final fromDate = sleep.fromDate;
                  final toDate = sleep.toDate;
                  String formattedDateRange = '';
                  List<double> data = [];
                  if (fromDate != null && toDate != null) {
                    formattedDateRange = fromDate.formmatDateRange(
                      endDate: toDate,
                    );
                  }

                  return ActivityItemWidget(
                    title: formattedDateRange,
                    value: "",
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
