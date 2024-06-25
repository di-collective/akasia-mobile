import '../../../core/utils/service_locator.dart';
import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/local/config_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/config_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/config_repository.dart';
import '../domain/usecase/confirm_password_reset_usecase.dart';
import '../domain/usecase/forgot_password_usecase.dart';
import '../domain/usecase/get_access_token_usecase.dart';
import '../domain/usecase/get_yaml_usecase.dart';
import '../domain/usecase/save_access_token_usecase.dart';
import '../domain/usecase/sign_in_use_case.dart';
import '../domain/usecase/sign_out_use_case.dart';
import '../domain/usecase/sign_up_usecase.dart';
import '../domain/usecase/update_password_usecase.dart';
import '../presentation/cubit/create_new_password/create_new_password_cubit.dart';
import '../presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../presentation/cubit/sign_in/sign_in_cubit.dart';
import '../presentation/cubit/sign_up/sign_up_cubit.dart';
import '../presentation/cubit/yaml/yaml_cubit.dart';

class AuthDI {
  AuthDI._();

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
    sl.registerLazySingleton<ConfigLocalDataSource>(() {
      return ConfigLocalDataSourceImpl();
    });
    sl.registerLazySingleton<AuthLocalDataSource>(() {
      return AuthLocalDataSourceImpl(
        sharedPreferences: sl(),
      );
    });
    sl.registerLazySingleton<AuthRemoteDataSource>(() {
      return AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        googleSignIn: sl(),
        appHttpClient: sl(),
        authLocalDataSource: sl(),
        sharedPreferences: sl(),
      );
    });
  }

  static void _injectRepositories() {
    sl.registerLazySingleton<ConfigRepository>(() {
      return ConfigRepositoryImpl(
        configLocalDataSource: sl(),
      );
    });
    sl.registerLazySingleton<AuthRepository>(() {
      return AuthRepositoryImpl(
        networkInfo: sl(),
        authRemoteDataSource: sl(),
        authLocalDataSource: sl(),
      );
    });
  }

  static void _injectUseCases() {
    sl.registerLazySingleton<GetYamlUseCase>(() {
      return GetYamlUseCase(
        configRepository: sl(),
      );
    });
    sl.registerLazySingleton<SignUpUseCase>(() {
      return SignUpUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<SignInUseCase>(() {
      return SignInUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<ForgotPasswordUseCase>(() {
      return ForgotPasswordUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<ConfirmPasswordResetUseCase>(() {
      return ConfirmPasswordResetUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<UpdatePasswordUseCase>(() {
      return UpdatePasswordUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<SignOutUseCase>(() {
      return SignOutUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<GetAccessTokenUseCase>(() {
      return GetAccessTokenUseCase(
        authRepository: sl(),
      );
    });
    sl.registerLazySingleton<SaveAccessTokenUseCase>(() {
      return SaveAccessTokenUseCase(
        authRepository: sl(),
      );
    });
  }

  static void _injectCubits() {
    sl.registerFactory<YamlCubit>(() {
      return YamlCubit(
        getYamlUseCase: sl(),
      );
    });
    sl.registerFactory<SignInCubit>(() {
      return SignInCubit(
        signInUseCase: sl(),
      );
    });
    sl.registerFactory<SignUpCubit>(() {
      return SignUpCubit(
        signUpUseCase: sl(),
      );
    });
    sl.registerFactory<ForgotPasswordCubit>(() {
      return ForgotPasswordCubit(
        forgotPasswordUseCase: sl(),
      );
    });
    sl.registerFactory<CreateNewPasswordCubit>(() {
      return CreateNewPasswordCubit(
        confirmPasswordResetUseCase: sl(),
        updatePasswordUseCase: sl(),
      );
    });
  }
}
