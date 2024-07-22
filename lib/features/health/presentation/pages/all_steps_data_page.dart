import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../cubit/steps/steps_cubit.dart';

class AllStepsDataPage extends StatelessWidget {
  const AllStepsDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
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
                itemCount: steps.length,
                primary: false,
                shrinkWrap: true,
                reverse: true,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final step = steps[index];

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetIconsPath.icWatch,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.date?.formatDate(
                                      format: 'dd MMMM yyyy',
                                    ) ??
                                    '',
                                style: textTheme.bodyMedium.copyWith(
                                  color: colorScheme.onSurfaceBright,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "${step.count ?? 0} ${context.locale.steps}",
                                style: textTheme.titleSmall.copyWith(
                                  color: colorScheme.onSurfaceDim,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ShimmerLoading.rectangular(
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading.rectangular(
                          height: 12,
                          width: context.width * 0.3,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        ShimmerLoading.rectangular(
                          height: 20,
                          width: context.width * 0.5,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
