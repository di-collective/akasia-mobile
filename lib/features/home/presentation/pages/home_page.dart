import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
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
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: CustomScrollView(
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
                          children: [
                            HomeDashboardItemWidget(
                              iconSvgPath: AssetIconsPath.icPoint,
                              title: context.locale.myRewardPoints,
                              description: "2.900pts",
                              onTap: _onMyRewardPoints,
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 35,
                              child: VerticalDivider(
                                color: Color(0xFFF69459),
                              ),
                            ),
                            const Spacer(),
                            HomeDashboardItemWidget(
                              iconSvgPath: AssetIconsPath.icCalendar,
                              title: context.locale.nextSchedule,
                              description: null,
                              onTap: _onNextSchedule,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                      Text(
                        context.locale.membership,
                        style: textTheme.titleMedium.copyWith(
                          color: colorScheme.onSurfaceDim,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        context.locale.askCashierToScanThisBarcode,
                        style: textTheme.labelMedium.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const MembershipBarcodeWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    // TODO: Implement this method
  }

  void _onSuccessStory() {
    // TODO: Implement this method
  }

  void _onTreatment() {
    // TODO: Implement this method
  }

  void _onDietPlan() {
    // TODO: Implement this method
  }
}
