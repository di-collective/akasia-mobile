import '../../../core/ui/extensions/hive_box_extension.dart';
import '../../../core/utils/service_locator.dart';
import '../data/datasources/health_local_datasource.dart';
import '../data/repositories/health_repository_impl.dart';
import '../domain/repositories/activity_repository.dart';
import '../domain/usecases/get_steps_usecase.dart';
import '../presentation/cubit/daily_heart_rate/daily_heart_rate_cubit.dart';
import '../presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';
import '../presentation/cubit/daily_sleep/daily_sleep_cubit.dart';
import '../presentation/cubit/daily_workouts/daily_workouts_cubit.dart';
import '../presentation/cubit/steps/steps_cubit.dart';

class HealthDI {
  const HealthDI._();

  static void inject() {
    // data sources
    _injectDataSources();

    // repositories
    _injectRepositories();

    // use cases
    _injectUseCases();

    // cubits
    _injectCubits();
  }

  static void _injectDataSources() {
    sl.registerLazySingleton<HealthLocalDataSource>(() {
      return HealthLocalDataSourceImpl(
        healthService: sl(),
        activityBox: HiveBox.activity.box(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<HealthRepository>(() {
      return HealthRepositoryImpl(
        healthLocalDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetStepsUseCase>(() {
      return GetStepsUseCase(
        healthRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<StepsCubit>(() {
      return StepsCubit(
        getStepsUseCase: sl(),
      );
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
