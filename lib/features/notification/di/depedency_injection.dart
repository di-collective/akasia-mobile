import '../../../core/utils/service_locator.dart';
import '../data/datasources/notification_remote_datasource.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../presentation/cubit/notifications/notifications_cubit.dart';

class NotificationDI {
  NotificationDI._();

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
    sl.registerLazySingleton<NotificationRemoteDataSource>(() {
      return NotificationRemoteDataSourceImpl(
        appHttpClient: sl(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<NotificationRepository>(() {
      return NotificationRepositoryImpl(
        networkInfo: sl(),
        authLocalDataSource: sl(),
        notificationRemoteDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetNotificationsUseCase>(() {
      return GetNotificationsUseCase(
        notificationRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<NotificationsCubit>(() {
      return NotificationsCubit(
        getNotificationsUseCase: sl(),
      );
    });
  }
}
