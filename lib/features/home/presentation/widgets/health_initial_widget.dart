import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class HealthInitialWidget extends StatelessWidget {
  final Function() onConnect;

  const HealthInitialWidget({
    super.key,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      width: context.width,
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
            onTap: onConnect,
          ),
        ],
      ),
    );
  }
}
