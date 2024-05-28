import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/ui/localization/app_supported_locales.dart';
import '../core/ui/theme/theme.dart';
import '../core/ui/widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import '../core/ui/widget/loadings/full_screen_loading_widget.dart';
import '../features/account/presentation/cubit/allergies/allergies_cubit.dart';
import '../features/account/presentation/cubit/emergency_contact/emergency_contact_cubit.dart';
import '../features/auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../features/main/presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import 'routes/app_route_info.dart';
import '../core/utils/service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FullScreenLoadingCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<YamlCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<BottomNavigationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<AllergiesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<EmergencyContactCubit>(),
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
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              BlocBuilder<FullScreenLoadingCubit, FullScreenLoadingState>(
                builder: (context, state) {
                  if (state is ShowFullScreenLoading) {
                    return FullScreenLoadingWidget(
                      message: state.message,
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            ],
          );
        },
      ),
    );
  }
}
