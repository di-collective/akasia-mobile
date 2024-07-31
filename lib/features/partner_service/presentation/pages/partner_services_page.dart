import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/app_partner_extension.dart';
import '../../../../core/ui/extensions/app_partner_status_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../health/presentation/cubit/health_service/health_service_cubit.dart';
import '../widgets/partner_item_widget.dart';
import 'partner_connect_page.dart';

class PartnerServicesPage extends StatefulWidget {
  const PartnerServicesPage({super.key});

  @override
  State<PartnerServicesPage> createState() => _PartnerServicesPageState();
}

class _PartnerServicesPageState extends State<PartnerServicesPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.partnerServices,
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
            if (Platform.isIOS) ...[
              PartnerItemWidget(
                imagePath: AppPartner.healthKit.logoPath,
                title: AppPartner.healthKit.title,
                description: AppPartner.healthKit.types(
                  context: context,
                ),
                onTap: () => _onPartner(
                  partner: AppPartner.healthKit,
                ),
              ),
            ] else if (Platform.isAndroid) ...[
              PartnerItemWidget(
                imagePath: AppPartner.healthConnect.logoPath,
                title: AppPartner.healthConnect.title,
                description: AppPartner.healthConnect.types(
                  context: context,
                ),
                onTap: () => _onPartner(
                  partner: AppPartner.healthConnect,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onPartner({
    required AppPartner partner,
  }) async {
    try {
      // show loading
      context.showFullScreenLoading();

      AppPartnerStatus? status = AppPartnerStatus.disconnected;
      switch (partner) {
        case AppPartner.healthConnect:
        case AppPartner.healthKit:
          // check if user has permissions
          final isAuthorized =
              await BlocProvider.of<HealthServiceCubit>(context)
                  .hasPermissions();
          status = AppPartnerStatusExtension.toAppPartnerStatus(
            isAuthorized,
          );

          break;
      }

      // go to partner connect page
      context.goNamed(
        AppRoute.partnerConnect.name,
        extra: PartnerConnectPageParams(
          partner: partner,
          status: status,
        ),
      );
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }
}
