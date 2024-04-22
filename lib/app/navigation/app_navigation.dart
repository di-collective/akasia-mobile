import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/account/presentation/account_screen.dart';
import '../../feature/home/presentation/home_screen.dart';
import '../../feature/info/presentation/info_screen.dart';
import '../../feature/my_treatment/presentation/my_treatment_screen.dart';
import '../../feature/dashboard/presentation/dashboard_screen.dart';

abstract final class AppNavigation {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/home',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: HomeScreen(
                        onNavigateToSomeScreen: (param) {},
                      ),
                    );
                  }),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my_treatment',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: MyTreatmentScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/info',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: InfoScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: AccountScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
