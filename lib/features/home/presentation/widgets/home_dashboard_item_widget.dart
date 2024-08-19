import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class HomeDashboardItemWidget extends StatelessWidget {
  final String iconSvgPath;
  final String title;
  final String? description;
  final bool isLoading;
  final Function() onTap;

  const HomeDashboardItemWidget({
    super.key,
    required this.iconSvgPath,
    required this.title,
    this.description,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final width = (context.width - (2 * context.paddingHorizontal)) * 0.45;

    if (isLoading) {
      return SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerLoading.rectangular(
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    ShimmerLoading.rectangular(
                      height: 16,
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                ShimmerLoading.rectangular(
                  height: 16,
                  width: width * 0.7,
                ),
              ],
            ),
            ShimmerLoading.rectangular(
              height: 16,
              width: 16,
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        iconSvgPath,
                        height: 12,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.labelSmall.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    description ?? '-',
                    style: textTheme.labelMedium.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AssetIconsPath.icChevronRight,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
