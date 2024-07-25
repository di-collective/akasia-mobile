import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/open_app_info.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/services/health_service.dart';
import '../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../../health/presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../../../health/presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';
import '../../../health/presentation/cubit/sleep/sleep_cubit.dart';
import '../../../health/presentation/cubit/workout/workout_cubit.dart';
import '../../../health/presentation/cubit/steps/steps_cubit.dart';
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

    // init health
    _initHealth();
  }

  Future<void> _initHealth() async {
    try {
      // request health permission
      final isPermissionGranted = await sl<HealthService>().requestPermission();
      if (isPermissionGranted != true) {
        // not allowed access on health application
        return;
      }

      // get steps
      BlocProvider.of<StepsCubit>(context).getStepsInOneWeek();

      // get daily heart rate
      BlocProvider.of<HeartRateCubit>(context).getHeartRateInOneWeek();

      // get daily nutritions
      BlocProvider.of<DailyNutritionsCubit>(context).getDailyNutritions();

      // get daily workouts
      BlocProvider.of<WorkoutCubit>(context).getWorkoutInOneWeek();

      // get daily sleep
      BlocProvider.of<SleepCubit>(context).getSleepInOneWeek();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _onGetProfile() async {
    await BlocProvider.of<ProfileCubit>(context).getProfile();
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
  }) async {
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

    // TODO: Check if user has filled personal information
    if (item == BottomNavigationItem.myTreatment) {
      // if personal information is null, navigate to fill personal information
      final isContinue = await context.pushNamed(
        AppRoute.fillPersonalInformation.name,
      );
      if (isContinue != true) {
        return;
      }
    }

    BlocProvider.of<BottomNavigationCubit>(context).onChanged(
      item,
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
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
