import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/depedency_injection.dart';
import '../../../../core/common/open_app_info.dart';
import '../../../../core/ui/extensions/asset_name_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';
import '../cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/bottom_nav_item.dart';

class MainPageParams {
  final int? selectedIndex;

  MainPageParams({
    this.selectedIndex,
  });
}

class MainPage extends StatefulWidget {
  final MainPageParams? params;

  const MainPage({
    super.key,
    this.params,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    if (widget.params?.selectedIndex != null) {
      final selectedIndex = widget.params!.selectedIndex!;

      // init selected bottom navigation
      BlocProvider.of<BottomNavigationCubit>(context).onChanged(
        selectedIndex,
      );
    } else {
      // init bottom navigation
      BlocProvider.of<BottomNavigationCubit>(context).init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: const Center(
            child: Text('Main Page'),
          ),
          bottomNavigationBar: AppBottomNavBar(
            selectedIndex: state.selectedIndex,
            onTap: (index) {
              if (index == null) {
                // chat us navigation tapped
                // open phone
                _onOpenChatUse();
              } else {
                BlocProvider.of<BottomNavigationCubit>(context).onChanged(
                  index,
                );
              }
            },
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
                index: 3,
                label: context.locale.info,
                iconAssetName: 'ic_info.svg'.iconAsset,
              ),
              AppBottomNavItemData(
                index: 4,
                label: context.locale.account,
                iconAssetName: 'ic_account.svg'.iconAsset,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onOpenChatUse() async {
    try {
      final telUrl =
          '6281234567890'.toTelpUrl; // TODO: change to real phone number
      await sl<OpenAppInfo>().openLink(
        url: telUrl,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
