import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class RecomendationItemWidget extends StatelessWidget {
  const RecomendationItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 139,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.bottomCenter,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "Mengenal Teknik LAMS Andalan Akasia 365mc Body Aesthetics Center, Teknolog"
              .toCapitalizes(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceDim,
          ),
        ),
        const Spacer(),
        Text(
          "9 Feb 2024, 20:14 ",
          maxLines: 1,
          style: textTheme.bodySmall.copyWith(
            color: colorScheme.onSurfaceBright,
          ),
        ),
      ],
    );
  }
}
