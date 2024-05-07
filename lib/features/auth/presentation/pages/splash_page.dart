import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/asset_path.dart';
import '../../../../app/navigation/app_route.dart';
import '../../../../core/ui/extensions/app_route_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    try {
      final result = await Future.wait([
        // minimum splash duration
        Future.delayed(const Duration(seconds: 3)),

        // check sign in status
        _isSignIn(),
      ]);

      // check sign in status
      final bool isSignIn = result[1];

      if (isSignIn) {
        // go to main page
        context.go(AppRoute.main.path);

        return;
      }

      // go to sign in page
      context.go(AppRoute.signIn.path);
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  Future<bool> _isSignIn() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      return false;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.theme.appColorScheme;

    return Scaffold(
      backgroundColor: color.primary,
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetPath.logoTextWhite,
              height: 35,
            ),
            SizedBox(
              height: context.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
