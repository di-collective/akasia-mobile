import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class NotificationLoadingItemWidget extends StatelessWidget {
  const NotificationLoadingItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingHorizontal,
        vertical: 10,
      ),
      child: Row(
        children: [
          ShimmerLoading.circular(
            width: 34,
            height: 34,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading.circular(
                  width: context.width * 0.6,
                  height: 20,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ShimmerLoading.circular(
                  width: context.width,
                  height: 16,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
