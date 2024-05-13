import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/extensions/app_route_parsing.dart';

enum AppRoute {
  splash,
  main,
  signIn,
  signUp,
  forgotPassword,
  createNewPassword,
}

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
            ],
          ),
        ],
      ),
      AppRoute.main.route(),
    ],
  );
}
