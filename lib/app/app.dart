import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/ui/localization/app_supported_locales.dart';
import '../core/ui/theme/theme.dart';
import '../core/ui/widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import '../core/ui/widget/loadings/full_screen_loading_widget.dart';
import '../core/utils/service_locator.dart';
import '../features/account/presentation/cubit/profile/profile_cubit.dart';
import '../features/appointment/presentation/cubit/appointments/appointments_cubit.dart';
import '../features/auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../features/diet_plan/presentation/cubit/eat_calendar/eat_calendar_cubit.dart';
import '../features/health/presentation/cubit/health_service/health_service_cubit.dart';
import '../features/health/presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../features/health/presentation/cubit/nutrition/nutrition_cubit.dart';
import '../features/health/presentation/cubit/sleep/sleep_cubit.dart';
import '../features/health/presentation/cubit/steps/steps_cubit.dart';
import '../features/health/presentation/cubit/workout/workout_cubit.dart';
import '../features/main/presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../features/my_treatment/presentation/cubit/weight_goal/weight_goal_cubit.dart';
import '../features/my_treatment/presentation/cubit/weight_history/weight_history_cubit.dart';
import '../features/notification/presentation/cubit/notifications/notifications_cubit.dart';
import 'routes/app_route_info.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FullScreenLoadingCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<YamlCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<BottomNavigationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<AppointmentsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<EatCalendarCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HealthServiceCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<StepsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HeartRateCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<NutritionCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<WorkoutCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SleepCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<WeightGoalCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<WeightHistoryCubit>(),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        routeInformationParser: sl<AppRouteInfo>().route.routeInformationParser,
        routerDelegate: sl<AppRouteInfo>().route.routerDelegate,
        routeInformationProvider:
            sl<AppRouteInfo>().route.routeInformationProvider,
        locale: Locale(
          AppSupportedLocales.en.languageCode,
        ),
        supportedLocales: AppSupportedLocales.values.map(
          (e) => Locale(
            e.languageCode,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              BlocBuilder<FullScreenLoadingCubit, FullScreenLoadingState>(
                builder: (context, state) {
                  if (state is ShowFullScreenLoading) {
                    return FullScreenLoadingWidget(
                      message: state.message,
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            ],
          );
        },
      ),
    );
  }
}
