import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ActivityItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final Function()? onTap;
  final bool isFirst;
  final bool isLast;

  const ActivityItemWidget({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Material(
      color: colorScheme.white,
      borderRadius: _borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(
                AssetIconsPath.icWatch,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceBright,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      value,
                      style: textTheme.titleSmall.copyWith(
                        color: colorScheme.onSurfaceDim,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  AssetIconsPath.icChevronRight,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurfaceBright,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius get _borderRadius {
    return BorderRadius.vertical(
      top: Radius.circular(isFirst ? 20 : 0),
      bottom: Radius.circular(isLast ? 20 : 0),
    );
  }
}
