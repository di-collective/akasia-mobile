import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/depedency_injection.dart';
import '../../../../core/common/open_app_info.dart';
import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';
import '../cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../widget/bottom_nav_bar.dart';

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
      if (selectedIndex < BottomNavigationItem.values.length) {
        // init selected bottom navigation
        final item = BottomNavigationItem.values[selectedIndex];
        BlocProvider.of<BottomNavigationCubit>(context).onChanged(
          item,
        );

        return;
      }
    }

    // init bottom navigation
    BlocProvider.of<BottomNavigationCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: state.selectedItem.bodyWidget,
          bottomNavigationBar: AppBottomNavBar(
            selectedItem: state.selectedItem,
            onTap: (item) {
              if (item == BottomNavigationItem.chatUs) {
                // chat us navigation tapped
                // open phone
                _onOpenChatUse();
              } else {
                BlocProvider.of<BottomNavigationCubit>(context).onChanged(
                  item,
                );
              }
            },
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
