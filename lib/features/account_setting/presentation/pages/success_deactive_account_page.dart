import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/cubit/countdown/countdown_cubit.dart';
import '../../../../core/utils/service_locator.dart';

class SuccessDeactiveAccountPage extends StatelessWidget {
  const SuccessDeactiveAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CountdownCubit>(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onStartCountdown();
  }

  void _onStartCountdown() {
    BlocProvider.of<CountdownCubit>(context).startCountdown(
      totalSeconds: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add a image
            const SizedBox(
              height: 120,
            ),
            Text(
              context.locale.yourAccountHasBeenDeleted,
              style: textTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceDim,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              context.locale.thanksForUsingAkasia,
              style: textTheme.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            BlocConsumer<CountdownCubit, CountdownState>(
              listener: (context, state) {
                if (state is CountdownStop) {
                  // go to splash
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    context.goNamed(AppRoute.splash.name);
                  });
                }
              },
              builder: (context, state) {
                if (state is CountdownLoading) {
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.locale.backIn,
                        ),
                        TextSpan(
                          text:
                              ' ${state.currentSeconds} ${context.locale.second}',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      style: textTheme.labelMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
