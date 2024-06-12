import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/open_app_info.dart';
import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/datasources/help_center_config.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
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
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingHorizontal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        "${context.locale.needHelp}?".toCapitalize(),
                        style: textTheme.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${context.locale.talkToUs}!".toCapitalize(),
                        style: textTheme.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: _onChatSupport,
                  child: Container(
                    padding: EdgeInsets.all(
                      context.paddingHorizontal,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outlineBright,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary,
                          ),
                          child: SvgPicture.asset(
                            AssetIconsPath.icChatDouble,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.locale.chatSupport,
                                style: textTheme.labelLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurfaceDim,
                                ),
                              ),
                              Text(
                                context.locale.chatDirectlyWithOurCsTeam,
                                style: textTheme.labelMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SvgPicture.asset(
                          AssetIconsPath.icChevronRight,
                          height: 8,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onSurfaceBright,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Text(
                    context.locale.alternativelyCallUs(
                      HelpCenterConfig.phone,
                      HelpCenterConfig.email,
                    ),
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingHorizontal,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          text: context.locale.callNow,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          borderColor: colorScheme.primary,
                          textColor: colorScheme.primary,
                          backgroundColor: Colors.transparent,
                          onTap: _onCallNow,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonWidget(
                          text: context.locale.emailNow,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          onTap: _onEmailNow,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingHorizontal,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.surface,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.ourLocation,
                        style: textTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Mayapada Hospital Jakarta Selatan, Tower 2, 6th Floor",
                        style: textTheme.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceDim,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Jl. Lebak Bulus I Kav. 29, Cilandak Barat, Kec.Cilandak, Jakarta Selatan - DKI Jakarta 12430.",
                        style: textTheme.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingHorizontal,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.operationHour,
                        style: textTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(
                              text: "Mon-Fir · ",
                            ),
                            TextSpan(
                              text: "08:00 - 17:00",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                        style: textTheme.labelLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(
                              text: "Sat \t\t\t\t\t\t\t\t· ",
                            ),
                            TextSpan(
                              text: "08:00 - 16:00",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                        style: textTheme.labelLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        context.locale.sundayAndPublicHolidayClosed,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.paddingBottom,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onChatSupport() async {
    try {
      const whatsappNumber = HelpCenterConfig.whatsappNumber;

      try {
        // open whatsapp
        await sl<OpenAppInfo>().openLink(
          url: whatsappNumber.toWhatsappUrl,
        );
      } catch (error) {
        // if whatsapp error, try open phone telphone
        await sl<OpenAppInfo>().openLink(
          url: whatsappNumber.toTelpUrl,
        );
      }
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  Future<void> _onCallNow() async {
    try {
      const phoneNumber = HelpCenterConfig.phone;

      // open telp
      await sl<OpenAppInfo>().openLink(
        url: phoneNumber.toTelpUrl,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  Future<void> _onEmailNow() async {
    try {
      const email = HelpCenterConfig.email;

      // open email
      await sl<OpenAppInfo>().openLink(
        url: email.toEmailUrl,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
