import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';

class PartnerItemWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool? isConnected;
  final Function() onTap;

  const PartnerItemWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineBright,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: textTheme.labelLarge.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    style: textTheme.bodyMedium.copyWith(
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
              _iconPath,
              colorFilter: ColorFilter.mode(
                _iconColor(
                  colorScheme: colorScheme,
                ),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    );
  }

  String get _iconPath {
    if (isConnected == true) {
      return AssetIconsPath.icCheck;
    } else {
      return AssetIconsPath.icChevronRight;
    }
  }

  Color _iconColor({
    required AppColorScheme colorScheme,
  }) {
    if (isConnected == true) {
      return colorScheme.primary;
    } else {
      return colorScheme.onSurfaceBright;
    }
  }
}
