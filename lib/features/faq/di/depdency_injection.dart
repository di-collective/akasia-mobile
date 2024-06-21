import '../../../core/utils/service_locator.dart';
import '../data/datasources/faq_local_datasource.dart';
import '../data/repositories/faq_repository_impl.dart';
import '../domain/repositories/faq_repository.dart';
import '../domain/usecases/get_faqs_usecase.dart';
import '../presentation/cubit/faqs/faqs_cubit.dart';

class FaqDI {
  FaqDI._();

  static void inject() {
    // datasources
    _injectDataSources();

    // repositories
    _injectRepositories();

    // usecases
    _injectUseCases();

    // cubits
    _injectCubits();
  }

  static void _injectDataSources() {
    sl.registerLazySingleton<FaqLocalDataSource>(() {
      return FaqLocalDataSourceImpl();
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<FaqRepository>(() {
      return FaqRepositoryImpl(
        faqLocalDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetFaqsUseCase>(() {
      return GetFaqsUseCase(
        faqRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<FaqsCubit>(() {
      return FaqsCubit(
        getFaqsUseCase: sl(),
      );
    });
  }
}
