import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_route.dart';
import '../../features/account/presentation/pages/edit_allergies_page.dart';
import '../../features/account/presentation/pages/edit_emergency_contact_page.dart';
import '../../features/account/presentation/pages/edit_information_page.dart';
import '../../features/account/presentation/pages/profile_page.dart';
import '../../features/account_setting/presentation/pages/account_setting_page.dart';
import '../../features/account_setting/presentation/pages/change_password_page.dart';
import '../../features/account_setting/presentation/pages/change_phone_number_page.dart';
import '../../features/account_setting/presentation/pages/deactive_account_page.dart';
import '../../features/account_setting/presentation/pages/success_deactive_account_page.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/success_create_new_password_page.dart';
import '../../features/faq/presentation/pages/faq_details_page.dart';
import '../../features/faq/presentation/pages/faq_page.dart';
import '../../features/main/presentation/pages/main_page.dart';

extension AppRouteExtension on AppRoute {
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
      case AppRoute.editEmergencyContact:
        return 'edit-emergency-contact';
      case AppRoute.accountSetting:
        return 'account-setting';
      case AppRoute.changePassword:
        return 'change-password';
      case AppRoute.changePhoneNumber:
        return 'change-phone-number';
      case AppRoute.deactiveAccount:
        return 'deactive-account';
      case AppRoute.successDeactiveAccount:
        return '/success-deactive-account';
      case AppRoute.faq:
        return 'faq';
      case AppRoute.faqDetails:
        return 'faq-details';
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
        return CreateNewPasswordPage(
          params: arguments,
        );
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
        return EditInformationPage(
          params: arguments,
        );
      case AppRoute.editAllergies:
        return EditAllergiesPage(
          params: arguments,
        );
      case AppRoute.editEmergencyContact:
        return EditEmergencyContactPage(
          params: arguments,
        );
      case AppRoute.accountSetting:
        return const AccountSettingPage();
      case AppRoute.changePassword:
        return const ChangePasswordPage();
      case AppRoute.changePhoneNumber:
        return const ChangePhoneNumberPage();
      case AppRoute.deactiveAccount:
        return const DeactiveAccountPage();
      case AppRoute.successDeactiveAccount:
        return const SuccessDeactiveAccountPage();
      case AppRoute.faq:
        return const FaqPage();
      case AppRoute.faqDetails:
        return FaqDetailsPage(
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
