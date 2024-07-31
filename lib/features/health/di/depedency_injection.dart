import '../../../core/ui/extensions/hive_box_extension.dart';
import '../../../core/utils/service_locator.dart';
import '../data/datasources/health_local_datasource.dart';
import '../data/repositories/health_repository_impl.dart';
import '../domain/repositories/activity_repository.dart';
import '../domain/usecases/get_heart_rate_usecase.dart';
import '../domain/usecases/get_nutrition_usecase.dart';
import '../domain/usecases/get_sleep_usecase.dart';
import '../domain/usecases/get_steps_usecase.dart';
import '../domain/usecases/get_workout_usecase.dart';
import '../presentation/cubit/health_service/health_service_cubit.dart';
import '../presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../presentation/cubit/nutrition/nutrition_cubit.dart';
import '../presentation/cubit/sleep/sleep_cubit.dart';
import '../presentation/cubit/steps/steps_cubit.dart';
import '../presentation/cubit/workout/workout_cubit.dart';

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
    sl.registerLazySingleton<GetSleepUseCase>(() {
      return GetSleepUseCase(
        healthRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetHeartRateUseCase>(() {
      return GetHeartRateUseCase(
        healthRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetWorkoutUseCase>(() {
      return GetWorkoutUseCase(
        healthRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetNutritionUseCase>(() {
      return GetNutritionUseCase(
        healthRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<HealthServiceCubit>(() {
      return HealthServiceCubit(
        healthService: sl(),
      );
    });
    sl.registerFactory<StepsCubit>(() {
      return StepsCubit(
        getStepsUseCase: sl(),
        healthService: sl(),
      );
    });
    sl.registerFactory<HeartRateCubit>(() {
      return HeartRateCubit(
        healthService: sl(),
        getHeartRateUseCase: sl(),
      );
    });
    sl.registerFactory<NutritionCubit>(() {
      return NutritionCubit(
        getNutritionUseCase: sl(),
        healthService: sl(),
      );
    });
    sl.registerFactory<WorkoutCubit>(() {
      return WorkoutCubit(
        getWorkoutUseCase: sl(),
        healthService: sl(),
      );
    });
    sl.registerFactory<SleepCubit>(() {
      return SleepCubit(
        getSleepUseCase: sl(),
        healthService: sl(),
      );
    });
  }
}
