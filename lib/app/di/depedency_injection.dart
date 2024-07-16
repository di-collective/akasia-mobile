import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/depedency_injection.dart';
import '../../core/network/http/dio_interceptor.dart';
import '../../core/utils/service_locator.dart';
import '../../features/account/di/depedency_injection.dart';
import '../../features/account_setting/di/depedency_injection.dart';
import '../../features/appointment/di/depedency_injection.dart';
import '../../features/auth/di/depedency_injection.dart';
import '../../features/country/di/depedency_injection.dart';
import '../../features/diet_plan/di/depedency_injection.dart';
import '../../features/faq/di/depdency_injection.dart';
import '../../features/heart_rate/di/depedency_injection.dart';
import '../../features/main/di/depedency_inject.dart';
import '../../features/my_schedule/di/depedency_injection.dart';
import '../../features/notification/di/depedency_injection.dart';
import '../../features/nutritions/di/depedency_injection.dart';
import '../../features/personal_information/di/depedency_injection.dart';
import '../../features/ratings/di/depedency_injection.dart';
import '../../features/sleep/di/depedency_injection.dart';
import '../../features/steps/di/depedency_injection.dart';
import '../../features/workouts/di/depedency_injection.dart';

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

  AppointmentDI.inject();

  MyScheduleDI.inject();

  DietPlanDI.inject();

  StepsDI.inject();

  HeartRateDI.inject();

  NutritionsDI.inject();

  WorkoutsDI.inject();

  SleepDI.inject();
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
    return Dio()
      ..interceptors.add(
        DioInterceptor(),
      )
      ..options = BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      );
  });

  // image picker
  sl.registerLazySingleton<ImagePicker>(() {
    return ImagePicker();
  });

  // app links
  sl.registerLazySingleton<AppLinks>(() {
    return AppLinks();
  });

  // flutter downloader
  await FlutterDownloader.initialize(
    debug: kDebugMode,
    ignoreSsl: true,
  );
}
