import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/ui/extensions/app_partner_extension.dart';
import '../../../../core/ui/extensions/app_partner_status_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/bottom_sheet_button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../health/presentation/cubit/health_service/health_service_cubit.dart';

class PartnerConnectPageParams {
  final AppPartner partner;
  final AppPartnerStatus status;

  const PartnerConnectPageParams({
    required this.partner,
    required this.status,
  });
}

class PartnerConnectPage extends StatefulWidget {
  final PartnerConnectPageParams? params;

  const PartnerConnectPage({
    super.key,
    this.params,
  });

  @override
  State<PartnerConnectPage> createState() => _PartnerConnectPageState();
}

class _PartnerConnectPageState extends State<PartnerConnectPage> {
  AppPartner? partner;
  AppPartnerStatus? status;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    partner = widget.params?.partner;
    status = widget.params?.status;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.params == null) {
      return const SizedBox.shrink();
    }

    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.white,
        iconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: context.height * 0.3,
                  ),
                  // TODO: Image
                  const NetworkImageWidget(
                    size: Size(82, 82),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      _title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium.copyWith(
                        color: colorScheme.onSurfaceDim,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    _description,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomSheetButtonWidget(
            text: _buttonLabel,
            width: context.width,
            onTap: _onConnect,
          ),
        ],
      ),
    );
  }

  String get _title {
    if (partner == null) {
      return '';
    }

    switch (partner!) {
      case AppPartner.healthKit:
        return context.locale.connectAppToPartner(
          AppConfig.appName,
          partner!.title,
        );
      case AppPartner.healthConnect:
        return context.locale.connectAppToPartner(
          AppConfig.appName,
          partner!.title,
        );
    }
  }

  String get _description {
    if (partner == null) {
      return '';
    }

    switch (partner!) {
      case AppPartner.healthKit:
        return context.locale.connectHealthPartnerToAppDescription(
          AppConfig.appName,
          partner!.title,
        );
      case AppPartner.healthConnect:
        return context.locale.connectHealthPartnerToAppDescription(
          AppConfig.appName,
          partner!.title,
        );
    }
  }

  String? get _buttonLabel {
    if (status == null) {
      return null;
    }

    switch (status!) {
      case AppPartnerStatus.connected:
        return context.locale.disconnect;
      case AppPartnerStatus.disconnected:
        return context.locale.connect;
    }
  }

  Future<void> _onConnect() async {
    try {
      if (partner == null) {
        return;
      }

      // show loading
      context.showFullScreenLoading();

      // connect to partner
      switch (partner!) {
        case AppPartner.healthKit:
        case AppPartner.healthConnect:
          // connect to health service
          final isSuccess = await _onConnectHealth();
          if (isSuccess != true) {
            return;
          }

          break;
      }

      // show toast
      context.showSuccessToast(
        message: context.locale.successItem(
          _buttonLabel ?? '',
        ),
      );

      // change status
      setState(() {
        status = AppPartnerStatusExtension.toggle(status);
      });
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }

  Future<bool?> _onConnectHealth() async {
    try {
      if (status == null) {
        return null;
      }

      switch (status!) {
        case AppPartnerStatus.connected:
          // disconnect
          return await BlocProvider.of<HealthServiceCubit>(context)
              .disconnect();

        case AppPartnerStatus.disconnected:
          // connect
          return await BlocProvider.of<HealthServiceCubit>(context).connect();
      }
    } catch (_) {
      rethrow;
    }
  }
}
