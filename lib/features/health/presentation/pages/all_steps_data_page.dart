import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../cubit/steps/steps_cubit.dart';
import '../widgets/activity_item_widget.dart';
import '../widgets/actvity_item_loading_widget.dart';

class AllStepsDataPage extends StatefulWidget {
  const AllStepsDataPage({super.key});

  @override
  State<AllStepsDataPage> createState() => _AllStepsDataPageState();
}

class _AllStepsDataPageState extends State<AllStepsDataPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetStepsAll();
  }

  Future<void> _onGetStepsAll() async {
    await BlocProvider.of<StepsCubit>(context).getStepsAll();
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
      body: BlocBuilder<StepsCubit, StepsState>(
        builder: (context, state) {
          if (state is StepsLoaded) {
            final steps = state.steps?.data;
            if (steps == null || steps.isEmpty) {
              return const StateEmptyWidget();
            }

            return ListView.separated(
              itemCount: steps.length,
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
                final step = steps[index];

                return ActivityItemWidget(
                  isFirst: index == 0,
                  isLast: index == steps.length - 1,
                  title: step.date?.formatDate(
                        format: 'dd MMMM yyyy',
                      ) ??
                      '',
                  value: "${step.count ?? 0} ${context.locale.stepsUnit}",
                );
              },
            );
          } else if (state is StepsError) {
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
