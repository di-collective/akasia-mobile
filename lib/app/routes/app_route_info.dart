import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_route.dart';
import 'app_route_extension.dart';

abstract class AppRouteInfo {
  GlobalKey<NavigatorState> get navigatorKey;
  GoRouter get route;
}

class AppRouteInfoImpl implements AppRouteInfo {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter _router = GoRouter(
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: _navigatorKey,
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
          AppRoute.accountSetting.route(
            routes: [
              AppRoute.changePassword.route(),
              AppRoute.changePhoneNumber.route(),
              AppRoute.deactiveAccount.route(),
            ],
          ),
        ],
      ),
      AppRoute.successDeactiveAccount.route(),
    ],
  );

  @override
  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  @override
  GoRouter get route {
    return _router;
  }
}