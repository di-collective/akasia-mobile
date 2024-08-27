import 'package:akasia365mc/core/ui/extensions/color_swatch_extension.dart';
import 'package:akasia365mc/core/ui/extensions/theme_data_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../../appointment/presentation/cubit/appointments/appointments_cubit.dart';
import '../../../health/presentation/cubit/heart_rate/heart_rate_cubit.dart';
import '../../../health/presentation/cubit/nutrition/nutrition_cubit.dart';
import '../../../health/presentation/cubit/sleep/sleep_cubit.dart';
import '../../../health/presentation/cubit/steps/steps_cubit.dart';
import '../../../health/presentation/cubit/workout/workout_cubit.dart';
import '../widgets/heatlh_activities_widget.dart';
import '../widgets/home_dashboard_item_widget.dart';
import '../widgets/home_menu_item_widget.dart';
import '../widgets/membership_barcode_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // init get my schedules
    _initGetMySchedules();
  }

  void _initGetMySchedules() {
    final appointmentsState = BlocProvider.of<AppointmentsCubit>(context).state;
    if (appointmentsState is! AppointmentsLoaded) {
      _onGetMySchedules();
    }
  }

  Future<void> _onGetMySchedules() async {
    await BlocProvider.of<AppointmentsCubit>(context).getMySchedules();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 200,
              actions: [
                SizedBox(
                  width: context.paddingHorizontal,
                ),
                SvgPicture.asset(
                  AssetImagesPath.logoTextWhite,
                  height: 17,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onNotifications,
                  child: SvgPicture.asset(
                    AssetIconsPath.icNotification,
                    height: 25,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: _onProfile,
                  child: SvgPicture.asset(
                    AssetIconsPath.icProfile,
                    height: 23,
                  ),
                ),
                SizedBox(
                  width: context.paddingHorizontal,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF37021),
                        Color(0xFFF3762A),
                        Color(0xFFF69459),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.paddingHorizontal,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HomeDashboardItemWidget(
                                iconSvgPath: AssetIconsPath.icPoint,
                                title: context.locale.myRewardPoints,
                                description: "0 pts",
                                isLoading: false,
                                onTap: _onMyRewardPoints,
                              ),
                              SizedBox(
                                height: 35,
                                child: VerticalDivider(
                                  color: colorScheme.vividTangelo.tint90,
                                  width: 18,
                                  thickness: 0.5,
                                ),
                              ),
                              BlocBuilder<AppointmentsCubit, AppointmentsState>(
                                builder: (context, state) {
                                  String? nextAppointment;
                                  if (state is AppointmentsLoaded) {
                                    final appointment = state.nextAppointment;
                                    if (appointment != null) {
                                      final startDate =
                                          appointment.startTime?.toDateTime();

                                      if (startDate != null) {
                                        // format 7 Feb 2024 - 19:00
                                        nextAppointment = startDate.formatDate(
                                          format: 'd MMM y - HH:mm',
                                        );
                                      }
                                    }
                                  }

                                  nextAppointment ??= context
                                      .locale.noUpcomingSchedule
                                      .toCapitalize();

                                  return HomeDashboardItemWidget(
                                    iconSvgPath: AssetIconsPath.icCalendar,
                                    title: context.locale.nextSchedule,
                                    description: nextAppointment,
                                    isLoading: state is AppointmentsLoading,
                                    onTap: _onNextSchedule,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.large,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HomeMenuItemWidget(
                                  iconSvgPath: AssetIconsPath.icSuccessStory,
                                  title: context.locale.successStory,
                                  onTap: _onSuccessStory,
                                ),
                                HomeMenuItemWidget(
                                  iconSvgPath: AssetIconsPath.icTreatment,
                                  title: context.locale.treatment,
                                  onTap: _onTreatment,
                                ),
                                HomeMenuItemWidget(
                                  iconSvgPath: AssetIconsPath.icDietPlan,
                                  title: context.locale.dietPlan,
                                  onTap: _onDietPlan,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.paddingHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        const MembershipBarcodeWidget(),
                        const SizedBox(
                          height: 32,
                        ),
                        const HealthActivitiesWidget(),
                        SizedBox(
                          height: context.paddingBottom,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      await Future.wait([
        // get profile
        BlocProvider.of<ProfileCubit>(context).refreshGetProfile(),

        // get steps
        BlocProvider.of<StepsCubit>(context).refreshStepsInOneWeek(),

        // get heart rate
        BlocProvider.of<HeartRateCubit>(context).refreshHeartRateInOneWeek(),

        // get nutritions
        BlocProvider.of<NutritionCubit>(context).refreshNutritionInOneWeek(),

        // get workouts
        BlocProvider.of<WorkoutCubit>(context).refreshWorkoutInOneWeek(),

        // get sleep
        BlocProvider.of<SleepCubit>(context).refreshSleepInOneWeek(),
      ]);
    } catch (error) {
      // show toast
      sl<ToastInfo>().show(
        context: context,
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  void _onNotifications() {
    // go to notifications page
    context.goNamed(
      AppRoute.notifications.name,
    );
  }

  void _onProfile() {
    // go to profile page
    context.goNamed(
      AppRoute.profile.name,
    );
  }

  void _onMyRewardPoints() {
    // TODO: Implement this method
  }

  void _onNextSchedule() {
    // go to my schedule
    context.goNamed(
      AppRoute.mySchedule.name,
    );
  }

  void _onSuccessStory() {
    // TODO: Implement this method
  }

  void _onTreatment() {
    // TODO: Implement this method
  }

  void _onDietPlan() {
    // go to diet plan
    context.goNamed(
      AppRoute.dietPlan.name,
    );
  }
}
