import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/app_partner_extension.dart';

class PartnerConnectPageParams {
  final AppPartner partner;

  const PartnerConnectPageParams({
    required this.partner,
  });
}

class PartnerConnectPage extends StatelessWidget {
  final PartnerConnectPageParams? params;

  const PartnerConnectPage({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
