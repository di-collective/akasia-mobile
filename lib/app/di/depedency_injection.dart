import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/depedency_injection.dart';
import '../../core/network/http/dio_interceptor.dart';
import '../../core/utils/service_locator.dart';
import '../../features/account/di/depedency_injection.dart';
import '../../features/account_setting/di/depedency_injection.dart';
import '../../features/auth/di/depedency_injection.dart';
import '../../features/country/di/depedency_injection.dart';
import '../../features/faq/di/depdency_injection.dart';
import '../../features/main/di/depedency_inject.dart';
import '../../features/notification/di/depedency_injection.dart';
import '../../features/personal_information/di/depedency_injection.dart';
import '../../features/ratings/di/depedency_injection.dart';

Future<void> init() async {
  await _injectPackages();

  CoreDI.inject();

  CountryDI.inject();

  AuthDI.inject();

  MainDI.inject();

  AccountDI.inject();

  AccountSettingDI.inject();

  RatingsDI.inject();

  FaqDI.inject();

  NotificationDI.inject();

  PersonalInformationDI.inject();
}

Future<void> _injectPackages() async {
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
