import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../../app/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../widgets/home_dashboard_item_widget.dart';
import '../widgets/home_menu_item_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

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
                      GestureDetector(
                        onTap: () => _onShowBrightnessBarcode(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          width: context.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.outlineBright,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: 'ABC-abc-1234',
                                height: 80,
                                width: 250,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetIconsPath.icSun,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    context.locale.brightness,
                                    style: textTheme.labelMedium.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
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
    // TODO: Implement this method
  }

  void _onProfile() {
    // TODO: Implement this method
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

  Future<void> _onShowBrightnessBarcode(BuildContext context) async {
    // get current brightness
    final lastBrightness = await ScreenBrightness().system;

    await ScreenBrightness().setAutoReset(true);

    // set brightness to maximum
    await ScreenBrightness().setScreenBrightness(1);

    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    // show dialog with barcode
    await showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.membership,
                      style: textTheme.titleMedium.copyWith(
                        color: colorScheme.onSurfaceDim,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: 'ABC-abc-1234',
                      height: 90,
                      width: 300,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const CircleBorder(),
              child: Icon(
                Icons.close,
                color: colorScheme.primary,
              ),
            )
          ],
        );
      },
    );

    // reset brightness to last value
    await ScreenBrightness().setScreenBrightness(lastBrightness);
  }
}
