import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_route.dart';
import 'app_route_extension.dart';

class AppRouteInfo {
  static GoRouter route = GoRouter(
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: kDebugMode,
    routes: [
      AppRoute.splash.route(),
      AppRoute.signIn.route(
        routes: [
          AppRoute.signUp.route(),
          AppRoute.forgotPassword.route(
            routes: [
              AppRoute.createNewPassword.route(),
              AppRoute.successCreateNewPassword.route(),
            ],
          ),
        ],
      ),
      AppRoute.main.route(
        routes: [
          AppRoute.profile.route(
            routes: [
              AppRoute.editInformation.route(),
              AppRoute.editAllergies.route(),
              AppRoute.editEmergencyContact.route(),
            ],
          ),
        ],
      ),
    ],
  );
}
