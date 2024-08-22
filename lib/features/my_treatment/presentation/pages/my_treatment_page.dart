import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../cubit/weight_goal/weight_goal_cubit.dart';
import '../cubit/weight_history/weight_history_cubit.dart';
import '../widgets/emergency_call_widget.dart';
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
              BlocBuilder<WeightHistoryCubit, WeightHistoryState>(
                builder: (context, state) {
                  if (state is WeightHistoryLoading) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ShimmerLoading.rectangular(
                                height: 26,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            ShimmerLoading.rectangular(
                              height: 26,
                              width: 50,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerLoading.rectangular(
                                height: 26,
                                width: 50,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ListView.separated(
                                itemCount: 5,
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return ShimmerLoading.rectangular(
                                    height: 30,
                                    width: 50,
                                  );
                                },
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ShimmerLoading.rectangular(
                                    height: 48,
                                    width: 100,
                                  ),
                                  ShimmerLoading.rectangular(
                                    height: 48,
                                    width: 152,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is WeightHistoryError) {
                    return StateErrorWidget(
                      description: state.error.message(context),
                    );
                  }

                  return const WeightChartWidget();
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
    await BlocProvider.of<WeightHistoryCubit>(context).getWeightHistory();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      // get weight history
      BlocProvider.of<WeightHistoryCubit>(context).refreshWeightHistory(),

      // get weight goal
      BlocProvider.of<WeightGoalCubit>(context).getWeightGoal(),
    ]);
  }
}
