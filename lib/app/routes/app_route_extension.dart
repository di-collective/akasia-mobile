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
import '../../features/appointment/presentation/pages/create_appointment_page.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/success_create_new_password_page.dart';
import '../../features/diet_plan/presentation/pages/add_eaten_food_page.dart';
import '../../features/diet_plan/presentation/pages/diet_plan_calendar_page.dart';
import '../../features/diet_plan/presentation/pages/diet_plan_page.dart';
import '../../features/faq/presentation/pages/faq_details_page.dart';
import '../../features/faq/presentation/pages/faq_page.dart';
import '../../features/health/presentation/pages/all_heart_rate_data_page.dart';
import '../../features/health/presentation/pages/all_sleep_data_page.dart';
import '../../features/health/presentation/pages/all_steps_data_page.dart';
import '../../features/health/presentation/pages/heart_rate_details_page.dart';
import '../../features/health/presentation/pages/heart_rate_page.dart';
import '../../features/health/presentation/pages/sleep_details_page.dart';
import '../../features/health/presentation/pages/sleep_page.dart';
import '../../features/health/presentation/pages/steps_page.dart';
import '../../features/health/presentation/pages/workout/all_workout_data_page.dart';
import '../../features/ten_days_workout/presentation/pages/day_workout_details_page.dart';
import '../../features/ten_days_workout/presentation/pages/ten_days_workout_page.dart';
import '../../features/health/presentation/pages/workout/workout_details_page.dart';
import '../../features/health/presentation/pages/workout/workout_page.dart';
import '../../features/help_center/presentation/pages/help_center_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/my_schedule/presentation/pages/my_schedule_page.dart';
import '../../features/notification/presentation/pages/notifications_page.dart';
import '../../features/personal_information/presentation/pages/fill_personal_information_page.dart';
import '../../features/ratings/presentation/pages/give_rating_page.dart';
import '../../features/ratings/presentation/pages/ratings_page.dart';
import '../../features/ratings/presentation/pages/write_review_page.dart';

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
      case AppRoute.ratings:
        return 'ratings';
      case AppRoute.helpCenter:
        return 'help-center';
      case AppRoute.notifications:
        return 'notifications';
      case AppRoute.giveRating:
        return 'give-ratings';
      case AppRoute.writeReview:
        return 'write-review';
      case AppRoute.fillPersonalInformation:
        return 'fill-personal-information';
      case AppRoute.createAppointment:
        return 'create-appointment';
      case AppRoute.mySchedule:
        return 'my-schedule';
      case AppRoute.dietPlan:
        return 'diet-plan';
      case AppRoute.addEat:
        return 'add-eat';
      case AppRoute.dietPlanCalendar:
        return 'diet-plan-calendar';
      case AppRoute.steps:
        return 'steps';
      case AppRoute.allStepsData:
        return 'all-steps-data';
      case AppRoute.sleep:
        return 'sleep';
      case AppRoute.allSleepData:
        return 'all-sleep-data';
      case AppRoute.sleepDetails:
        return 'sleep-details';
      case AppRoute.heartRate:
        return 'heart-rate';
      case AppRoute.allHeartRateData:
        return 'all-heart-rate-data';
      case AppRoute.heartRateDetails:
        return 'heart-rate-details';
      case AppRoute.workout:
        return 'workout';
      case AppRoute.allWorkoutData:
        return 'all-workout-data';
      case AppRoute.workoutDetails:
        return 'workout-details';
      case AppRoute.tenDaysWorkout:
        return 'ten-days-workout';
      case AppRoute.dayWorkoutDetails:
        return 'day-workout-details';
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
        CreateNewPasswordPageParams? params;
        if (arguments is CreateNewPasswordPageParams) {
          params = arguments;
        }

        return CreateNewPasswordPage(
          params: params,
        );
      case AppRoute.successCreateNewPassword:
        return const SuccessCreateNewPasswordPage();
      case AppRoute.signUp:
        return const SignUpPage();
      case AppRoute.main:
        MainPageParams? params;
        if (arguments is MainPageParams) {
          params = arguments;
        }

        return MainPage(
          params: params,
        );
      case AppRoute.profile:
        return const ProfilePage();
      case AppRoute.editInformation:
        EditInformationPageParams? params;
        if (arguments is EditInformationPageParams) {
          params = arguments;
        }

        return EditInformationPage(
          params: params,
        );
      case AppRoute.editAllergies:
        EditAllergiesPageParams? params;
        if (arguments is EditAllergiesPageParams) {
          params = arguments;
        }

        return EditAllergiesPage(
          params: params,
        );
      case AppRoute.editEmergencyContact:
        EditEmergencyContactPageParams? params;
        if (arguments is EditEmergencyContactPageParams) {
          params = arguments;
        }

        return EditEmergencyContactPage(
          params: params,
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
        FaqDetailsPageParams? params;
        if (arguments is FaqDetailsPageParams) {
          params = arguments;
        }

        return FaqDetailsPage(
          params: params,
        );
      case AppRoute.ratings:
        return const RatingsPage();
      case AppRoute.helpCenter:
        return const HelpCenterPage();
      case AppRoute.notifications:
        return const NotificationsPage();
      case AppRoute.giveRating:
        GiveRatingPageArgs? params;
        if (arguments is GiveRatingPageArgs) {
          params = arguments;
        }

        return GiveRatingPage(
          params: params,
        );
      case AppRoute.writeReview:
        WriteReviewPageArgs? params;
        if (arguments is WriteReviewPageArgs) {
          params = arguments;
        }

        return WriteReviewPage(
          args: params,
        );
      case AppRoute.fillPersonalInformation:
        return const FillPersonalInformationPage();
      case AppRoute.createAppointment:
        return const CreateAppointmentPage();
      case AppRoute.mySchedule:
        return const MySchedulePage();
      case AppRoute.dietPlan:
        return const DietPlanPage();
      case AppRoute.addEat:
        AddEatenFoodPageParams? params;
        if (arguments is AddEatenFoodPageParams) {
          params = arguments;
        }

        return AddEatenFoodPage(
          params: params,
        );
      case AppRoute.dietPlanCalendar:
        DietPlanCalendarPageParams? params;
        if (arguments is DietPlanCalendarPageParams) {
          params = arguments;
        }

        return DietPlanCalendarPage(
          params: params,
        );
      case AppRoute.steps:
        return const StepsPage();
      case AppRoute.allStepsData:
        return const AllStepsDataPage();
      case AppRoute.sleep:
        return const SleepPage();
      case AppRoute.allSleepData:
        return const AllSleepDataPage();
      case AppRoute.sleepDetails:
        SleepDetailsPageParams? params;
        if (arguments is SleepDetailsPageParams) {
          params = arguments;
        }

        return SleepDetailsPage(
          params: params,
        );
      case AppRoute.heartRate:
        return const HeartRatePage();
      case AppRoute.allHeartRateData:
        return const AllHeartRateDataPage();
      case AppRoute.heartRateDetails:
        HeartRateDetailsPageParams? params;
        if (arguments is HeartRateDetailsPageParams) {
          params = arguments;
        }

        return HeartRateDetailsPage(
          params: params,
        );
      case AppRoute.workout:
        return const WorkoutPage();
      case AppRoute.allWorkoutData:
        return const AllWorkoutDataPage();
      case AppRoute.workoutDetails:
        WorkoutDetailsPageParams? params;
        if (arguments is WorkoutDetailsPageParams) {
          params = arguments;
        }

        return WorkoutDetailsPage(
          params: params,
        );
      case AppRoute.tenDaysWorkout:
        return const TenDaysWorkoutPage();
      case AppRoute.dayWorkoutDetails:
        return const DayWorkoutDetailsPage();
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
