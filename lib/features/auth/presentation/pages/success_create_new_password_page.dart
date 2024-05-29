import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';

class SuccessCreateNewPasswordPage extends StatelessWidget {
  const SuccessCreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add a image
            const SizedBox(
              height: 120,
            ),
            Text(
              context.locale.successResetPassword,
              style: textTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceDim,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonWidget(
              text: context.locale.loginNow,
              onTap: () => _onLoginNow(
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginNow({
    required BuildContext context,
  }) {
    context.goNamed(AppRoute.signIn.name);
  }
}
