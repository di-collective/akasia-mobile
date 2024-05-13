import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/navigation/app_route.dart';
import '../../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../../features/auth/presentation/pages/sign_in_page.dart';
import '../../../features/auth/presentation/pages/sign_up_page.dart';
import '../../../features/auth/presentation/pages/splash_page.dart';
import '../../../features/main/presentation/pages/main_page.dart';

extension AppRouteParsing on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.signIn:
        return '/sign-in';
      case AppRoute.forgotPassword:
        return 'forgot-password';
      case AppRoute.createNewPassword:
        return 'create-new-password';
      case AppRoute.signUp:
        return 'sign-up';
      case AppRoute.main:
        return '/main';
    }
  }

  Widget widget({
    Map? arguments,
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
      case AppRoute.signUp:
        return const SignUpPage();
      case AppRoute.main:
        final params = arguments?['params'] as MainPageParams?;

        return MainPage(
          params: params,
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

        if (extra != null && extra is Map) {
          return widget(arguments: extra);
        }

        return widget();
      },
    );
  }
}
