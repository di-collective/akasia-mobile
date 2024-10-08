import '../../../core/utils/service_locator.dart';
import '../data/datasources/remote/account_remote_datasource.dart';
import '../data/repositories/account_repository_impl.dart';
import '../domain/repositories/account_repository.dart';
import '../domain/usecases/change_profile_picture_usecase.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../presentation/cubit/edit_allergies/edit_allergies_cubit.dart';
import '../presentation/cubit/edit_emergency_contact/edit_emergency_contact_cubit.dart';
import '../presentation/cubit/profile/profile_cubit.dart';

final class AccountDI {
  AccountDI._();

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

  static Future<void> _injectDataSources() async {
    sl.registerLazySingleton<AccountRemoteDataSource>(() {
      return AccountRemoteDataSourceImpl(
        appHttpClient: sl(),
        imageCompressInfo: sl(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<AccountRepository>(() {
      return AccountRepositoryImpl(
        networkInfo: sl(),
        accountRemoteDataSource: sl(),
        authLocalDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<ChangeProfilePictureUseCase>(() {
      return ChangeProfilePictureUseCase(
        accountRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetProfileUseCase>(() {
      return GetProfileUseCase(
        accountRepository: sl(),
      );
    });
    sl.registerLazySingleton<UpdateProfileUseCase>(() {
      return UpdateProfileUseCase(
        accountRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<EditAllergiesCubit>(() {
      return EditAllergiesCubit(
        updateProfileUseCase: sl(),
      );
    });
    sl.registerFactory<EditEmergencyContactCubit>(() {
      return EditEmergencyContactCubit(
        updateProfileUseCase: sl(),
      );
    });
    sl.registerFactory<ProfileCubit>(() {
      return ProfileCubit(
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
      );
    });
  }
}
