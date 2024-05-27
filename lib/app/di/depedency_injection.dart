import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/directory_info.dart';
import '../../core/common/image_compress_info.dart';
import '../../core/common/local_picker_info.dart';
import '../../core/common/open_app_info.dart';
import '../../core/network/http/app_http_client.dart';
import '../../core/network/http/dio_interceptor.dart';
import '../../core/network/network_info.dart';
import '../../core/ui/widget/dialogs/toast_info.dart';
import '../../core/ui/widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import '../../features/account/data/datasources/remote/account_remote_datasource.dart';
import '../../features/account/data/datasources/remote/allergy_remote_datasource.dart';
import '../../features/account/data/repositories/account_repository_impl.dart';
import '../../features/account/data/repositories/allergy_repository_impl.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/domain/repositories/allergy_repository.dart';
import '../../features/account/domain/usecases/change_profile_picture_usecase.dart';
import '../../features/account/domain/usecases/get_allergies_usecase.dart';
import '../../features/account/presentation/cubit/edit_allergies/edit_allergies_cubit.dart';
import '../../features/account/presentation/cubit/edit_information/edit_information_cubit.dart';
import '../../features/account/presentation/cubit/allergies/allergies_cubit.dart';
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../features/auth/data/datasources/local/config_local_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/config_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/config_repository.dart';
import '../../features/auth/domain/usecase/confirm_password_reset_usecase.dart';
import '../../features/auth/domain/usecase/forgot_password_usecase.dart';
import '../../features/auth/domain/usecase/get_access_token_usecase.dart';
import '../../features/auth/domain/usecase/get_yaml_usecase.dart';
import '../../features/auth/domain/usecase/save_access_token_usecase.dart';
import '../../features/auth/domain/usecase/sign_in_use_case.dart';
import '../../features/auth/domain/usecase/sign_out_use_case.dart';
import '../../features/auth/domain/usecase/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/create_new_password/create_new_password_cubit.dart';
import '../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import '../../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import '../../features/auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../../features/main/presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _external();

  await _app();

  await _core();

  await _auth();

  await _main();

  await _account();
}

Future<void> _external() async {
  // Connectivity
  sl.registerLazySingleton<Connectivity>(() {
    return Connectivity();
  });

  // FirebaseAuth
  sl.registerLazySingleton<FirebaseAuth>(() {
    return FirebaseAuth.instance;
  });

  // GoogleSignIn
  sl.registerLazySingleton<GoogleSignIn>(() {
    return GoogleSignIn();
  });

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() {
    return sharedPreferences;
  });

  // dio
  sl.registerLazySingleton<Dio>(() {
    return Dio()..interceptors.add(DioInterceptor());
  });

  // image picker
  sl.registerLazySingleton<ImagePicker>(() {
    return ImagePicker();
  });
}

Future<void> _app() async {}

Future<void> _core() async {
  // toast info
  sl.registerLazySingleton<ToastInfo>(() {
    return ToastInfoImpl();
  });

  // network info
  sl.registerLazySingleton<NetworkInfo>(() {
    return NetworkInfoImpl(
      connectivity: sl(),
    );
  });

  // app http client
  sl.registerLazySingleton<AppHttpClient>(() {
    return AppHttpClient(
      dio: sl(),
    );
  });

  // open app info
  sl.registerLazySingleton<OpenAppInfo>(() {
    return const OpenAppInfoImpl();
  });

  // full screen loading cubit
  sl.registerFactory<FullScreenLoadingCubit>(() {
    return FullScreenLoadingCubit();
  });

  // local picker info
  sl.registerLazySingleton<LocalPickerInfo>(() {
    return LocalPickerInfoImpl(
      imagePicker: sl(),
    );
  });

  // directory info
  sl.registerLazySingleton<DirectoryInfo>(() {
    return const DirectoryInfoImpl();
  });

  // image compress info
  sl.registerLazySingleton<ImageCompressInfo>(() {
    return ImageCompressInfoImpl(
      directoryInfo: sl(),
    );
  });
}

Future<void> _auth() async {
  // data source
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

  // repository
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

  // use case
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

  // cubit
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
    );
  });
}

Future<void> _main() async {
  // cubit
  sl.registerFactory<BottomNavigationCubit>(() {
    return BottomNavigationCubit();
  });
}

Future<void> _account() async {
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

  // cubit
  sl.registerFactory<EditInformationCubit>(() {
    return EditInformationCubit();
  });
  sl.registerFactory<AllergiesCubit>(() {
    return AllergiesCubit(
      getAllergiesUseCase: sl(),
    );
  });
  sl.registerFactory<EditAllergiesCubit>(() {
    return EditAllergiesCubit();
  });
}