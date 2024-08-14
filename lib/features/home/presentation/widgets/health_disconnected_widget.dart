import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class HealthDisconnectedWidget extends StatelessWidget {
  final Function() onGoToSettings;

  const HealthDisconnectedWidget({
    super.key,
    required this.onGoToSettings,
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
            context.locale.grantPermission,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textTheme.titleMedium.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            context.locale.youWillNeedToGotToYourPhoneSettings,
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
            text: context.locale.goToSettings,
            height: 36,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            textColor: colorScheme.primary,
            backgroundColor: Colors.transparent,
            onTap: onGoToSettings,
          ),
        ],
      ),
    );
  }
}
