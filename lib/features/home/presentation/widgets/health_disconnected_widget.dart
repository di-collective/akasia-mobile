import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes/app_route_info.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../health/presentation/cubit/health_service/health_service_cubit.dart';

class HealthDisconnectedWidget extends StatefulWidget {
  const HealthDisconnectedWidget({super.key});

  @override
  State<HealthDisconnectedWidget> createState() =>
      _HealthDisconnectedWidgetState();
}

class _HealthDisconnectedWidgetState extends State<HealthDisconnectedWidget> {
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
            onTap: _onGoToSettings,
          ),
        ],
      ),
    );
  }

  Future<void> _onGoToSettings() async {
    final context = sl<AppRouteInfo>().navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    try {
      // show full screen loading
      context.showFullScreenLoading();

      // connect health service
      final isSuccess =
          await BlocProvider.of<HealthServiceCubit>(context).connect();
      if (isSuccess != true) {
        return;
      }

      // show toast
      context.showSuccessToast(
        message: context.locale.successItem(
          context.locale.connect,
        ),
      );
    } catch (error) {
      context.showErrorToast(
        message: context.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
