import 'package:flutter/material.dart';

import '../../config/asset_path.dart';
import 'build_context_extension.dart';

enum AppPartner {
  healthConnect,
  healthKit,
}

extension AppPartnerExtension on AppPartner {
  String get logoPath {
    switch (this) {
      case AppPartner.healthConnect:
        return AssetImagesPath.healthConnect;
      case AppPartner.healthKit:
        return AssetImagesPath.healthKit;
    }
  }

  String get title {
    switch (this) {
      case AppPartner.healthConnect:
        return 'Health Connect';
      case AppPartner.healthKit:
        return 'Apple Health';
    }
  }

  String types({
    required BuildContext context,
  }) {
    switch (this) {
      case AppPartner.healthConnect:
        return "${context.locale.health}, ${context.locale.watch}";
      case AppPartner.healthKit:
        return "${context.locale.health}, ${context.locale.watch}";
    }
  }
}
