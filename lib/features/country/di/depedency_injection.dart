import '../../../core/utils/service_locator.dart';
import '../data/datasources/local/country_local_datasource.dart';
import '../data/repositories/country_repository_impl.dart';
import '../domain/repositories/country_repository.dart';
import '../domain/usecases/get_countries_usecase.dart';
import '../presentation/cubit/countries/countries_cubit.dart';

class CountryDI {
  static void inject() {
    // data source
    _injectDataSources();

    // repository
    _injectRepositories();

    // use case
    _injectUseCases();

    // cubit
    _injectCubits();
  }

  static void _injectDataSources() {
    sl.registerLazySingleton<CountryLocalDataSource>(() {
      return CountryLocalDataSourceImpl();
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<CountryRepository>(() {
      return CountryRepositoryImpl(
        countryLocalDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetCountriesUseCase>(() {
      return GetCountriesUseCase(
        countryRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<CountriesCubit>(() {
      return CountriesCubit(
        getCountriesUseCase: sl(),
      );
    });
  }
}
