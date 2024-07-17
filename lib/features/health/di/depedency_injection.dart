import '../../../core/utils/service_locator.dart';
import '../data/datasources/health_service.dart';
import '../presentation/cubit/daily_heart_rate/daily_heart_rate_cubit.dart';
import '../presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';
import '../presentation/cubit/daily_sleep/daily_sleep_cubit.dart';
import '../presentation/cubit/daily_steps/daily_steps_cubit.dart';
import '../presentation/cubit/daily_workouts/daily_workouts_cubit.dart';

class HealthDI {
  const HealthDI._();

  static void inject() {
    // data sources
    _injectDataSources();

    // cubits
    _injectCubits();
  }

  static void _injectDataSources() {
    sl.registerLazySingleton<HealthService>(() {
      return HealthServiceImpl(
        health: sl(),
        permissionInfo: sl(),
      );
    });
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailyStepsCubit>(() {
      return DailyStepsCubit();
    });
    sl.registerFactory<DailyHeartRateCubit>(() {
      return DailyHeartRateCubit();
    });
    sl.registerFactory<DailyNutritionsCubit>(() {
      return DailyNutritionsCubit();
    });
    sl.registerFactory<DailyWorkoutsCubit>(() {
      return DailyWorkoutsCubit();
    });
    sl.registerFactory<DailySleepCubit>(() {
      return DailySleepCubit();
    });
  }
}
