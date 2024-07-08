import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../widgets/setting_item_widget.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.accountSettings,
          style: TextStyle(
            color: colorScheme.onSurfaceDim,
          ),
        ),
        backgroundColor: colorScheme.white,
        iconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            SettingItemWidget(
              title: context.locale.changePassword,
              onTap: () => _onChangePassword(context),
            ),
            SettingItemWidget(
              title: context.locale.changePhoneNumber,
              onTap: () => _onChangePhoneNumber(context),
            ),
            SettingItemWidget(
              title: context.locale.deactiveAccount,
              titleColor: colorScheme.error,
              onTap: () => _onDeactiveAccount(context),
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onChangePassword(BuildContext context) {
    // go to change password page
    context.goNamed(AppRoute.changePassword.name);
  }

  void _onChangePhoneNumber(BuildContext context) {
    // go to change phone number page
    context.goNamed(AppRoute.changePhoneNumber.name);
  }

  void _onDeactiveAccount(BuildContext context) {
    // go to deactive account page
    context.goNamed(AppRoute.deactiveAccount.name);
  }
}
