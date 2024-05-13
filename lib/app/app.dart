import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/ui/localization/app_supported_locales.dart';
import '../core/ui/theme/theme.dart';
import '../features/main/presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import 'di/depedency_injection.dart';
import 'navigation/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<BottomNavigationCubit>(),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        routeInformationParser: AppRouteInfo.route.routeInformationParser,
        routerDelegate: AppRouteInfo.route.routerDelegate,
        routeInformationProvider: AppRouteInfo.route.routeInformationProvider,
        locale: Locale(
          AppSupportedLocales.en.languageCode,
        ),
        supportedLocales: AppSupportedLocales.values.map(
          (e) => Locale(
            e.languageCode,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
