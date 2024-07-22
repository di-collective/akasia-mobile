import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class ActivityItemLoadingWidget extends StatelessWidget {
  const ActivityItemLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ShimmerLoading.rectangular(
            height: 24,
            width: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading.rectangular(
                height: 12,
                width: context.width * 0.3,
              ),
              const SizedBox(
                height: 2,
              ),
              ShimmerLoading.rectangular(
                height: 20,
                width: context.width * 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
