// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../core/ui/extensions/app_route_parsing.dart';
// import '../../features/account/presentation/account_screen.dart';
// import '../../features/auth/presentation/pages/splash_page.dart';
// import '../../features/main/presentation/pages/dashboard_screen.dart';
// import '../../features/home/presentation/home_screen.dart';
// import '../../features/info/presentation/info_screen.dart';
// import '../../features/my_treatment/presentation/my_treatment_screen.dart';
// import 'app_route.dart';

//   class AppNavigation {
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
//   static final GoRouter router = GoRouter(
//     debugLogDiagnostics: kDebugMode,
//     initialLocation: AppRoute.splash.route,
//     navigatorKey: _rootNavigatorKey,
//     routes: [
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return DashboardScreen(navigationShell: navigationShell,);
//         },
//         branches: [
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoute.splash.route,
//                 pageBuilder: (context, state) {
//                   return const NoTransitionPage(
//                     child: SplashPage(),
//                   );
//                 },
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                   path: '/home',
//                   pageBuilder: (context, state) {
//                     return NoTransitionPage(
//                       child: HomeScreen(
//                         onNavigateToSomeScreen: (param) {},
//                       ),
//                     );
//                   }),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/my_treatment',
//                 pageBuilder: (context, state) {
//                   return const NoTransitionPage(
//                     child: MyTreatmentScreen(),
//                   );
//                 },
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/info',
//                 pageBuilder: (context, state) {
//                   return const NoTransitionPage(
//                     child: InfoScreen(),
//                   );
//                 },
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/account',
//                 pageBuilder: (context, state) {
//                   return const NoTransitionPage(
//                     child: AccountScreen(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );
// }
