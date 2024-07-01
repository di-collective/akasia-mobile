import '../../../core/utils/service_locator.dart';
import '../data/datasources/clinic_remote_datasource.dart';
import '../data/repositories/clinic_repository_impl.dart';
import '../domain/repositories/clinic_repository.dart';
import '../domain/usecases/get_clinic_locations_usecase.dart';
import '../domain/usecases/get_clinics_usecase.dart';
import '../presentation/cubit/clinic_locations/clinic_locations_cubit.dart';
import '../presentation/cubit/clinics/clinics_cubit.dart';
import '../presentation/cubit/create_appointment/create_appointment_cubit.dart';

class AppointmentDI {
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
    sl.registerLazySingleton<ClinicRemoteDataSource>(() {
      return ClinicRemoteDataSourceImpl(
        appHttpClient: sl(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<ClinicRepository>(() {
      return ClinicRepositoryImpl(
        networkInfo: sl(),
        authLocalDataSource: sl(),
        clinicRemoteDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetClinicsUseCase>(() {
      return GetClinicsUseCase(
        clinicRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetClinicLocationsUseCase>(() {
      return GetClinicLocationsUseCase(
        clinicRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<ClinicsCubit>(() {
      return ClinicsCubit(
        getClinicsUseCase: sl(),
      );
    });
    sl.registerFactory<ClinicLocationsCubit>(() {
      return ClinicLocationsCubit(
        getClinicLocationsUseCase: sl(),
      );
    });
    sl.registerFactory<CreateAppointmentCubit>(() {
      return CreateAppointmentCubit();
    });
  }
}
