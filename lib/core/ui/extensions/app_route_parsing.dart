import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/navigation/app_route.dart';
import '../../../features/account/presentation/pages/edit_allergies_page.dart';
import '../../../features/account/presentation/pages/edit_information_page.dart';
import '../../../features/account/presentation/pages/profile_page.dart';
import '../../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../../features/auth/presentation/pages/sign_in_page.dart';
import '../../../features/auth/presentation/pages/sign_up_page.dart';
import '../../../features/auth/presentation/pages/splash_page.dart';
import '../../../features/auth/presentation/pages/success_create_new_password_page.dart';
import '../../../features/main/presentation/pages/main_page.dart';

extension AppRouteParsing on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.signIn:
        return '/sign-in';
      case AppRoute.forgotPassword:
        return 'forgot-password';
      case AppRoute.createNewPassword:
        return 'create-new-password';
      case AppRoute.successCreateNewPassword:
        return 'success-create-new-password';
      case AppRoute.signUp:
        return 'sign-up';
      case AppRoute.main:
        return '/main';
      case AppRoute.profile:
        return 'profile';
      case AppRoute.editInformation:
        return 'edit-information';
      case AppRoute.editAllergies:
        return 'edit-allergies';
    }
  }

  Widget widget<T>({
    T? arguments,
  }) {
    switch (this) {
      case AppRoute.splash:
        return const SplashPage();
      case AppRoute.signIn:
        return const SignInPage();
      case AppRoute.forgotPassword:
        return const ForgotPasswordPage();
      case AppRoute.createNewPassword:
        return const CreateNewPasswordPage();
      case AppRoute.successCreateNewPassword:
        return const SuccessCreateNewPasswordPage();
      case AppRoute.signUp:
        return const SignUpPage();
      case AppRoute.main:
        return MainPage(
          params: arguments,
        );
      case AppRoute.profile:
        return const ProfilePage();
      case AppRoute.editInformation:
        return const EditInformationPage();
      case AppRoute.editAllergies:
        return EditAllergiesPage(
          params: arguments,
        );
    }
  }

  GoRoute route({
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes,
      builder: (context, state) {
        final extra = state.extra;

        return widget(
          arguments: extra,
        );
      },
    );
  }
}
