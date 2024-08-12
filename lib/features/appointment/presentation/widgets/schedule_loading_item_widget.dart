import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/color_swatch_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class ScheduleLoadingItemWidget extends StatelessWidget {
  final int index;

  const ScheduleLoadingItemWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      height: 74,
      child: Row(
        children: [
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: index % 2 == 0
                  ? colorScheme.primary
                  : colorScheme.vividTangelo.tint90,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineBright,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading.circular(
                    width: context.width * 0.6,
                    height: 20,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  ShimmerLoading.circular(
                    width: context.width,
                    height: 16,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLoading.circular(
                        width: context.width * 0.2,
                        height: 16,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      ShimmerLoading.circular(
                        width: context.width * 0.2,
                        height: 16,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
