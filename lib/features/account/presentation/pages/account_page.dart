import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../widgets/account_item_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.paddingTop,
              ),
              const NetworkImageWidget(
                size: Size(120, 120),
                shape: BoxShape.circle,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'John Doe',
                style: textTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              AccountItemWidget(
                title: context.locale.informationDetails,
                onTap: _onInformationDetails,
              ),
              AccountItemWidget(
                title: context.locale.accountSettings,
                onTap: _onAccountSettings,
              ),
              AccountItemWidget(
                title: context.locale.faq,
                onTap: _onFaq,
              ),
              AccountItemWidget(
                title: context.locale.helpCenter,
                onTap: _onHelpCenter,
              ),
              AccountItemWidget(
                title: context.locale.termsAndConditions,
                onTap: _onTermsAndConditions,
              ),
              AccountItemWidget(
                title: context.locale.privacyPolicy,
                onTap: _onPrivacyPolicy,
              ),
              AccountItemWidget(
                title: context.locale.ratings,
                onTap: _onRatings,
              ),
              AccountItemWidget(
                title: context.locale.logout,
                titleColor: colorScheme.error,
                onTap: _onLogout,
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<YamlCubit, YamlState>(
                builder: (context, state) {
                  String? version;

                  if (state is YamlLoaded) {
                    version = state.yaml.version;
                  }

                  return Text(
                    '${context.locale.appVersion} ${version ?? ''}',
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onInformationDetails() {
    // TODO: Implement this method
  }

  void _onAccountSettings() {
    // TODO: Implement this method
  }

  void _onFaq() {
    // TODO: Implement this method
  }

  void _onHelpCenter() {
    // TODO: Implement this method
  }

  void _onTermsAndConditions() {
    // TODO: Implement this method
  }

  void _onPrivacyPolicy() {
    // TODO: Implement this method
  }

  void _onRatings() {
    // TODO: Implement this method
  }

  void _onLogout() {
    // TODO: Implement this method
  }
}
