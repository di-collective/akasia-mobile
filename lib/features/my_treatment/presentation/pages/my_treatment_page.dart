import 'package:akasia365mc/core/ui/extensions/dynamic_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../domain/entities/weight_goal_entity.dart';
import '../cubit/weight_goal/weight_goal_cubit.dart';
import '../cubit/weight_history/weight_history_cubit.dart';
import '../widgets/emergency_call_widget.dart';
import '../widgets/weight_chart_loading_widget.dart';
import '../widgets/weight_chart_widget.dart';

class MyTreatmentPage extends StatefulWidget {
  const MyTreatmentPage({super.key});

  @override
  State<MyTreatmentPage> createState() => _MyTreatmentPageState();
}

class _MyTreatmentPageState extends State<MyTreatmentPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final weightHistoryState =
        BlocProvider.of<WeightHistoryCubit>(context).state;
    if (weightHistoryState is! WeightHistoryLoaded) {
      _onGetWeightHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.myTreatment,
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.paddingTop,
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String? phoneNumber;
                  if (state is ProfileLoaded) {
                    final ecPhone = state.profile.ecPhone;
                    final ecCountryCode = state.profile.ecCountryCode;
                    if (ecCountryCode != null && ecPhone != null) {
                      phoneNumber = "$ecCountryCode$ecPhone";
                    }
                  }

                  return EmergencyCallWidget(
                    isDisabled: phoneNumber == null,
                    phoneNumber: phoneNumber,
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<WeightGoalCubit, WeightGoalState>(
                builder: (context, state) {
                  WeightGoalEntity? weightGoal;
                  if (state is WeightGoalLoaded) {
                    weightGoal = state.weightGoal;
                  }
                  if (weightGoal == null) {
                    return const WeightChartWidget(
                      isDisabled: true,
                    );
                  }

                  return BlocBuilder<WeightHistoryCubit, WeightHistoryState>(
                    builder: (context, state) {
                      if (state is WeightHistoryLoading) {
                        return const WeightChartLoadingWidget();
                      } else if (state is WeightHistoryError) {
                        return StateErrorWidget(
                          width: context.width,
                          paddingTop: context.height * 0.2,
                          description: state.error.message(context),
                          buttonText: context.locale.refresh,
                          onTapButton: () {
                            _onRefresh(
                              isUseFullScreenLoading: true,
                            );
                          },
                        );
                      } else if (state is WeightHistoryLoaded) {
                        final weights = state.weights;
                        bool isDisabled = true;

                        final startDate =
                            weightGoal?.startingDate.dynamicToDateTime;
                        final targetDate =
                            weightGoal?.targetDate.dynamicToDateTime;
                        if (startDate != null && targetDate != null) {
                          final now = DateTime.now();
                          if (now.isAfter(startDate) &&
                              now.isBefore(targetDate)) {
                            isDisabled = false;
                          }
                        }

                        return WeightChartWidget(
                          isDisabled: isDisabled,
                          weights: weights,
                          weightGoal: weightGoal,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
              SizedBox(
                height: context.paddingBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onGetWeightHistory() async {
    String? startDate;
    final weightGoalState = BlocProvider.of<WeightGoalCubit>(context).state;
    if (weightGoalState is WeightGoalLoaded) {
      startDate = weightGoalState.weightGoal?.startingDate;
    }

    await BlocProvider.of<WeightHistoryCubit>(context).getWeightHistory(
      fromDate: startDate,
      toDate: DateTime.now().toString(),
    );
  }

  Future<void> _onRefresh({
    bool? isUseFullScreenLoading,
  }) async {
    try {
      if (isUseFullScreenLoading == true) {
        context.showFullScreenLoading();
      }

      String? startDate;
      final weightGoalState = BlocProvider.of<WeightGoalCubit>(context).state;
      if (weightGoalState is WeightGoalLoaded) {
        startDate = weightGoalState.weightGoal?.startingDate;
      }

      await Future.wait([
        // get weight history
        BlocProvider.of<WeightHistoryCubit>(context).refreshWeightHistory(
          fromDate: startDate,
          toDate: DateTime.now().toString(),
        ),

        // get weight goal
        BlocProvider.of<WeightGoalCubit>(context).getWeightGoal(),
      ]);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      if (isUseFullScreenLoading == true) {
        context.hideFullScreenLoading;
      }
    }
  }
}
