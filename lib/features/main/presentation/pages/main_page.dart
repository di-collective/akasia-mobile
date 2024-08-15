import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/open_app_info.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../../health/presentation/cubit/health_service/health_service_cubit.dart';
import '../../../my_treatment/domain/entities/weight_goal_entity.dart';
import '../../../my_treatment/presentation/cubit/weight_goal/weight_goal_cubit.dart';
import '../cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../widget/bottom_nav_bar.dart';

class MainPageParams {
  final BottomNavigationItem? selectedTab;

  MainPageParams({
    this.selectedTab,
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

    _init();
  }

  void _init() {
    // init selected bottom navigation
    final selectedTab = widget.params?.selectedTab;

    _onChange(
      item: selectedTab,
    );

    // check permission health service
    _onCheckPermissionHealthService();
  }

  Future<void> _onGetProfile() async {
    await BlocProvider.of<ProfileCubit>(context).getProfile();
  }

  Future<void> _onCheckPermissionHealthService() async {
    await BlocProvider.of<HealthServiceCubit>(context).hasPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
          ),
          child: Scaffold(
            body: state.selectedItem.bodyWidget,
            bottomNavigationBar: AppBottomNavBar(
              selectedItem: state.selectedItem,
              onTap: (item) {
                _onChange(
                  item: item,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onChange({
    required BottomNavigationItem? item,
  }) {
    if (item == null) {
      // if item null, init bottom navigation
      BlocProvider.of<BottomNavigationCubit>(context).init();

      // get profile
      final profileState = BlocProvider.of<ProfileCubit>(context).state;
      if (profileState is! ProfileLoaded) {
        // if state is not loaded, get data
        _onGetProfile();
      }

      return;
    }

    if (item == BottomNavigationItem.chatUs) {
      // if item is chat us, open chat us
      _onOpenChatUs();

      return;
    }

    if (item == BottomNavigationItem.myTreatment) {
      _onWeightGoal();

      return;
    }

    BlocProvider.of<BottomNavigationCubit>(context).onChanged(
      item,
    );
  }

  Future<void> _onWeightGoal() async {
    // check if user has weight goal
    final weightGoalState = BlocProvider.of<WeightGoalCubit>(context).state;
    WeightGoalEntity? weightGoal;
    if (weightGoalState is WeightGoalLoaded) {
      weightGoal = weightGoalState.weightGoal;
    } else {
      // if weight goal is not loaded, get weight goal
      weightGoal = await _onGetWeightGoal();
    }

    if (weightGoal == null) {
      // if weight goal is null, navigate to create weight goal
      final isContinue = await context.pushNamed(
        AppRoute.fillPersonalInformation.name,
      );
      if (isContinue != true) {
        return;
      }
    }

    // change bottom navigation to my treatment
    BlocProvider.of<BottomNavigationCubit>(context).onChanged(
      BottomNavigationItem.myTreatment,
    );
  }

  Future<WeightGoalEntity?> _onGetWeightGoal() async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      return await BlocProvider.of<WeightGoalCubit>(context).getWeightGoal();
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return null;
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
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
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
