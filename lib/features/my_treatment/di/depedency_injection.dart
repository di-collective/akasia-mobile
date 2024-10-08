import '../../../core/utils/service_locator.dart';
import '../data/datasources/weight_goal_remote_datasource.dart';
import '../data/repositories/weight_goal_repository_impl.dart';
import '../domain/repositories/weight_goal_repository.dart';
import '../domain/usecases/create_weight_goal_usecase.dart';
import '../domain/usecases/get_simulation_usecase.dart';
import '../domain/usecases/get_weight_goal_usecase.dart';
import '../domain/usecases/get_weight_history_usecase.dart';
import '../domain/usecases/update_weight_goal_usecase.dart';
import '../domain/usecases/update_weight_usecase.dart';
import '../presentation/cubit/simulation/simulation_cubit.dart';
import '../presentation/cubit/weight_goal/weight_goal_cubit.dart';
import '../presentation/cubit/weight_history/weight_history_cubit.dart';

class MyTreatmentDI {
  static void inject() {
    // inject data sources
    _injectDataSources();

    // inject repositories
    _injectRepositories();

    // inject use cases
    _injectUseCases();

    // inject cubits
    _injectCubits();
  }

  static void _injectDataSources() {
    sl.registerLazySingleton<WeightGoalRemoteDataSource>(() {
      return WeightGoalRemoteDataSourceImpl(
        appHttpClient: sl(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<WeightGoalRepository>(() {
      return WeightGoalRepositoryImpl(
        networkInfo: sl(),
        authLocalDataSource: sl(),
        weightGoalRemoteDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetWeightGoalUseCase>(() {
      return GetWeightGoalUseCase(
        weightGoalRepository: sl(),
      );
    });
    sl.registerLazySingleton<CreateWeightGoalUseCase>(() {
      return CreateWeightGoalUseCase(
        weightGoalRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetSimulationUseCase>(() {
      return GetSimulationUseCase(
        weightGoalRepository: sl(),
      );
    });
    sl.registerLazySingleton<UpdateWeightUseCase>(() {
      return UpdateWeightUseCase(
        weightGoalRepository: sl(),
      );
    });
    sl.registerLazySingleton<UpdateWeightGoalUseCase>(() {
      return UpdateWeightGoalUseCase(
        weightGoalRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetWeightHistoryUseCase>(() {
      return GetWeightHistoryUseCase(
        weightGoalRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<WeightGoalCubit>(() {
      return WeightGoalCubit(
        getWeightGoalUseCase: sl(),
        createWeightGoalUseCase: sl(),
        updateWeightGoalUseCase: sl(),
      );
    });
    sl.registerFactory<SimulationCubit>(() {
      return SimulationCubit(
        getSimulationUseCase: sl(),
      );
    });
    sl.registerFactory<WeightHistoryCubit>(() {
      return WeightHistoryCubit(
        updateWeightUseCase: sl(),
        getWeightHistoryUseCase: sl(),
      );
    });
  }
}
