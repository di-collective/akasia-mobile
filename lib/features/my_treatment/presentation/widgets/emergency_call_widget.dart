import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/open_app_info.dart';
import '../../../../core/config/asset_path.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/utils/service_locator.dart';

class EmergencyCallWidget extends StatefulWidget {
  final bool isDisabled;

  const EmergencyCallWidget({
    super.key,
    required this.isDisabled,
  });

  @override
  State<EmergencyCallWidget> createState() => _EmergencyCallWidgetState();
}

class _EmergencyCallWidgetState extends State<EmergencyCallWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isDisabled
              ? colorScheme.outlineDim
              : colorScheme.outlinePrimary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        color:
            widget.isDisabled ? colorScheme.surface : colorScheme.primaryTonal,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🚨 ${context.locale.emergencyCall}",
                  style: textTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: widget.isDisabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceDim,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  context.locale.dontHestiteToContactUse,
                  style: textTheme.bodySmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 7,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ButtonWidget(
            onTap: _onCall,
            width: 62,
            height: 62,
            backgroundColor: widget.isDisabled
                ? colorScheme.onSurfaceBright
                : colorScheme.primary,
            overlayColor: widget.isDisabled
                ? colorScheme.primary
                : colorScheme.onSurfaceBright,
            borderRadius: BorderRadius.circular(99),
            child: SvgPicture.asset(
              AssetIconsPath.icCall,
              colorFilter: ColorFilter.mode(
                colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onCall() async {
    try {
      if (widget.isDisabled) {
        return;
      }

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
