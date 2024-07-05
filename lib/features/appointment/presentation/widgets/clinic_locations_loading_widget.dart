import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

class ClinicLocationsLoadingWidget extends StatelessWidget {
  const ClinicLocationsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoading.circular(
          width: context.width * 0.6,
          height: 50,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: 5,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 20,
              );
            },
            itemBuilder: (context, index) {
              return ShimmerLoading.circular(
                width: context.width * 0.6,
                height: 40,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
