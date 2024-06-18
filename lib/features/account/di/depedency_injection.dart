import '../../../core/utils/service_locator.dart';
import '../data/datasources/remote/account_remote_datasource.dart';
import '../data/datasources/remote/allergy_remote_datasource.dart';
import '../data/repositories/account_repository_impl.dart';
import '../data/repositories/allergy_repository_impl.dart';
import '../domain/repositories/account_repository.dart';
import '../domain/repositories/allergy_repository.dart';
import '../domain/usecases/change_profile_picture_usecase.dart';
import '../domain/usecases/get_allergies_usecase.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../presentation/cubit/edit_allergies/edit_allergies_cubit.dart';
import '../presentation/cubit/edit_emergency_contact/edit_emergency_contact_cubit.dart';
import '../presentation/cubit/edit_information/edit_information_cubit.dart';
import '../presentation/cubit/profile/profile_cubit.dart';

final class FutureAccountDependencies {
  FutureAccountDependencies._();

  static Future<void> inject() async {
    // data source
    sl.registerLazySingleton<AccountRemoteDataSource>(() {
      return AccountRemoteDataSourceImpl(
        appHttpClient: sl(),
        imageCompressInfo: sl(),
      );
    });
    sl.registerLazySingleton<AllergyRemoteDataSource>(() {
      return AllergyRemoteDataSourceImpl(
        appHttpClient: sl(),
      );
    });

    // repository
    sl.registerLazySingleton<AccountRepository>(() {
      return AccountRepositoryImpl(
        networkInfo: sl(),
        accountRemoteDataSource: sl(),
        authLocalDataSource: sl(),
      );
    });
    sl.registerLazySingleton<AllergyRepository>(() {
      return AllergyRepositoryImpl(
        networkInfo: sl(),
        authLocalDataSource: sl(),
        allergyRemoteDataSource: sl(),
      );
    });

    // use case
    sl.registerLazySingleton<ChangeProfilePictureUseCase>(() {
      return ChangeProfilePictureUseCase(
        accountRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetAllergiesUseCase>(() {
      return GetAllergiesUseCase(
        allergyRepository: sl(),
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

    // cubit
    sl.registerFactory<EditInformationCubit>(() {
      return EditInformationCubit(
        updateProfileUseCase: sl(),
      );
    });
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
      );
    });
  }
}
