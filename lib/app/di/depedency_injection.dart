import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/deep_link_info.dart';
import '../../core/common/directory_info.dart';
import '../../core/common/image_compress_info.dart';
import '../../core/common/local_picker_info.dart';
import '../../core/common/open_app_info.dart';
import '../../core/network/http/app_http_client.dart';
import '../../core/network/http/dio_interceptor.dart';
import '../../core/network/network_info.dart';
import '../../core/ui/widget/dialogs/bottom_sheet_info.dart';
import '../../core/ui/widget/dialogs/toast_info.dart';
import '../../core/ui/widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import '../../core/utils/service_locator.dart';
import '../../features/account/data/datasources/remote/account_remote_datasource.dart';
import '../../features/account/data/datasources/remote/allergy_remote_datasource.dart';
import '../../features/account/data/datasources/remote/emergency_contact_remote_datasource.dart';
import '../../features/account/data/repositories/account_repository_impl.dart';
import '../../features/account/data/repositories/allergy_repository_impl.dart';
import '../../features/account/data/repositories/emergency_contact_repository.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/domain/repositories/allergy_repository.dart';
import '../../features/account/domain/repositories/emergency_contact_repository.dart';
import '../../features/account/domain/usecases/change_profile_picture_usecase.dart';
import '../../features/account/domain/usecases/edit_emergency_contact_usecase.dart';
import '../../features/account/domain/usecases/get_allergies_usecase.dart';
import '../../features/account/domain/usecases/get_emergency_contact_usecase.dart';
import '../../features/account/presentation/cubit/allergies/allergies_cubit.dart';
import '../../features/account/presentation/cubit/edit_allergies/edit_allergies_cubit.dart';
import '../../features/account/presentation/cubit/edit_emergency_contact/edit_emergency_contact_cubit.dart';
import '../../features/account/presentation/cubit/edit_information/edit_information_cubit.dart';
import '../../features/account/presentation/cubit/emergency_contact/emergency_contact_cubit.dart';
import '../../features/account_setting/presentation/cubit/change_password/change_password_cubit.dart';
import '../../features/activity_level/data/datasources/local/activity_level_local_datasource.dart';
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
import '../../features/auth/domain/usecase/update_password_usecase.dart';
import '../../features/auth/presentation/cubit/create_new_password/create_new_password_cubit.dart';
import '../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import '../../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import '../../features/auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../../features/country/data/datasources/local/country_local_datasource.dart';
import '../../features/country/data/repositories/country_repository_impl.dart';
import '../../features/country/domain/repositories/country_repository.dart';
import '../../features/country/domain/usecases/get_countries_usecase.dart';
import '../../features/country/presentation/cubit/countries/countries_cubit.dart';
import '../../features/main/presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../routes/app_route_info.dart';

Future<void> init() async {
  await _external();

  await _app();

  await _core();

  await _country();

  await _auth();

  await _main();

  await _account();

  await _activityLevel();

  await _accountSettings();
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

  // app links
  sl.registerLazySingleton<AppLinks>(() {
    return AppLinks();
  });
}

Future<void> _app() async {}

Future<void> _core() async {
  // app route info
  sl.registerLazySingleton<AppRouteInfo>(() {
    return AppRouteInfoImpl();
  });

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

  // bottom sheet info
  sl.registerLazySingleton<BottomSheetInfo>(() {
    return BottomSheetInfoImpl();
  });

  // deep link info
  sl.registerLazySingleton<DeepLinkInfo>(() {
    return DeepLinkInfoImpl(
      appLinks: sl(),
      appRouteInfo: sl(),
    );
  });
}

Future<void> _country() async {
  // data source
  sl.registerLazySingleton<CountryLocalDataSource>(() {
    return CountryLocalDataSourceImpl();
  });

  // repository
  sl.registerLazySingleton<CountryRepository>(() {
    return CountryRepositoryImpl(
      countryLocalDataSource: sl(),
    );
  });

  // use case
  sl.registerLazySingleton<GetCountriesUseCase>(() {
    return GetCountriesUseCase(
      countryRepository: sl(),
    );
  });

  // cubit
  sl.registerFactory<CountriesCubit>(() {
    return CountriesCubit(
      getCountriesUseCase: sl(),
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
      updatePasswordUseCase: sl(),
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
  sl.registerLazySingleton<EmergencyContactRemoteDataSource>(() {
    return EmergencyContactRemoteDataSourceImpl(
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
  sl.registerLazySingleton<EmergencyContactRepository>(() {
    return EmergencyContactRepositoryImpl(
      networkInfo: sl(),
      authLocalDataSource: sl(),
      emergencyContactRemoteDataSource: sl(),
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
  sl.registerLazySingleton<EditEmergencyContactUseCase>(() {
    return EditEmergencyContactUseCase(
      emergencyContactRepository: sl(),
    );
  });
  sl.registerLazySingleton<GetEmergencyContactUseCase>(() {
    return GetEmergencyContactUseCase(
      emergencyContactRepository: sl(),
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
  sl.registerFactory<EmergencyContactCubit>(() {
    return EmergencyContactCubit(
      getEmergencyContactUseCase: sl(),
    );
  });
  sl.registerFactory<EditEmergencyContactCubit>(() {
    return EditEmergencyContactCubit(
      editEmergencyContactUseCase: sl(),
    );
  });
}

Future<void> _activityLevel() async {
  // data source
  sl.registerLazySingleton<ActivityLevelLocalDataSource>(() {
    return ActivityLevelLocalDataSourceImpl();
  });
}

Future<void> _accountSettings() async {
  // Cubit
  sl.registerFactory<ChangePasswordCubit>(() {
    return ChangePasswordCubit();
  });
}
