import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class HealthInitialWidget extends StatefulWidget {
  const HealthInitialWidget({super.key});

  @override
  State<HealthInitialWidget> createState() => _HealthInitialWidgetState();
}

class _HealthInitialWidgetState extends State<HealthInitialWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineBright,
        ),
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
      ),
      child: Column(
        children: [
          const NetworkImageWidget(
            size: Size(120, 120),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            context.locale.connectToYourAppTo(
              AppConfig.appName,
            ),
            textAlign: TextAlign.center,
            maxLines: 5,
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(
            text: context.locale.connect,
            height: 36,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            onTap: _onConnect,
          ),
        ],
      ),
    );
  }

  void _onConnect() {
    // go to partner services
    context.goNamed(AppRoute.partnerServices.name);
  }
}
