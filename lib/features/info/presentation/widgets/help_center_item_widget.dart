import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class HelpCenterItemWidget extends StatelessWidget {
  const HelpCenterItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      height: 147,
      width: 147,
      padding: const EdgeInsets.only(
        left: 8,
        right: 10,
        top: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Informasi Biaya",
            style: textTheme.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SvgPicture.asset(
            AssetIconsPath.icArrowRight,
            height: 10,
          )
        ],
      ),
    );
  }
}
