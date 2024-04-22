import '../../../core/ui/extensions/asset_name_extension.dart';
import '../../../core/ui/extensions/build_context_extension.dart';
import 'widget/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../feature/dashboard/presentation/widget/bottom_nav_bar.dart';

@immutable
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  void onItemTap(int? index) {
    if (index != null && index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: selectedIndex,
        onTap: onItemTap,
        items: [
          AppBottomNavItemData(
            index: 0,
            label: context.locale.home,
            iconAssetName: 'ic_home.svg'.iconAsset,
          ),
          AppBottomNavItemData(
            index: 1,
            label: context.locale.myTreatment,
            iconAssetName: 'ic_my_treatment.svg'.iconAsset,
          ),
          AppBottomNavItemData(
            index: null,
            label: context.locale.chatUs,
            iconAssetName: 'ic_chat_us.svg'.iconAsset,
          ),
          AppBottomNavItemData(
            index: 2,
            label: context.locale.info,
            iconAssetName: 'ic_info.svg'.iconAsset,
          ),
          AppBottomNavItemData(
            index: 3,
            label: context.locale.account,
            iconAssetName: 'ic_account.svg'.iconAsset,
          ),
        ],
      ),
    );
  }
}
