import 'package:flutter/material.dart';

import '../../../features/account/presentation/pages/account_page.dart';
import '../../../features/home/presentation/home_page.dart';
import '../../../features/info/presentation/pages/info_page.dart';
import '../../../features/my_treatment/presentation/pages/my_treatment_page.dart';
import 'asset_name_extension.dart';
import 'build_context_extension.dart';

enum BottomNavigationItem {
  home,
  myTreatment,
  chatUs,
  info,
  account,
}

extension BottomNavigationItemParsing on BottomNavigationItem {
  String label(BuildContext context) {
    switch (this) {
      case BottomNavigationItem.home:
        return context.locale.home;
      case BottomNavigationItem.myTreatment:
        return context.locale.myTreatment;
      case BottomNavigationItem.chatUs:
        return context.locale.chatUs;
      case BottomNavigationItem.info:
        return context.locale.info;
      case BottomNavigationItem.account:
        return context.locale.account;
    }
  }

  String get iconPath {
    switch (this) {
      case BottomNavigationItem.home:
        return 'ic_home.svg'.iconAsset;
      case BottomNavigationItem.myTreatment:
        return 'ic_my_treatment.svg'.iconAsset;
      case BottomNavigationItem.chatUs:
        return 'ic_chat_us.svg'.iconAsset;
      case BottomNavigationItem.info:
        return 'ic_info.svg'.iconAsset;
      case BottomNavigationItem.account:
        return 'ic_account.svg'.iconAsset;
    }
  }

  Widget get bodyWidget {
    switch (this) {
      case BottomNavigationItem.home:
        return const HomePage();
      case BottomNavigationItem.myTreatment:
        return const MyTreatmentPage();
      case BottomNavigationItem.chatUs:
        return const SizedBox.shrink();
      case BottomNavigationItem.info:
        return const InfoPage();
      case BottomNavigationItem.account:
        return const AccountPage();
    }
  }
}
