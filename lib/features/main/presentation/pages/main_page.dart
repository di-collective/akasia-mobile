import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/service_locator.dart';
import '../../../../core/common/open_app_info.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../widget/bottom_nav_bar.dart';

class MainPageParams {
  final int? selectedIndex;

  MainPageParams({
    this.selectedIndex,
  });
}

class MainPage<T> extends StatefulWidget {
  final T? params;

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
                _onOpenChatUs();
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

  Future<void> _onOpenChatUs() async {
    try {
      final phoneNumber = EnvConfig.chatUsNumber.toString();
      try {
        // open whatsapp
        await sl<OpenAppInfo>().openLink(
          url: phoneNumber.toWhatsappUrl,
        );
      } catch (error) {
        // if whatsapp error, try open phone telphone
        await sl<OpenAppInfo>().openLink(
          url: phoneNumber.toTelpUrl,
        );
      }
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
