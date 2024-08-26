import 'package:flutter/material.dart';

import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class WeightChartLoadingWidget extends StatelessWidget {
  const WeightChartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ShimmerLoading.rectangular(
                height: 26,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            ShimmerLoading.rectangular(
              height: 26,
              width: 50,
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading.rectangular(
                height: 26,
                width: 50,
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.separated(
                itemCount: 5,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return ShimmerLoading.rectangular(
                    height: 30,
                    width: 50,
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerLoading.rectangular(
                    height: 48,
                    width: 100,
                  ),
                  ShimmerLoading.rectangular(
                    height: 48,
                    width: 152,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
