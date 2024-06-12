import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class TopicRecomendationItemWidget extends StatelessWidget {
  const TopicRecomendationItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;

    return SizedBox(
      height: 115,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: context.width * 0.35,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "*Kategori Berita* ",
                        maxLines: 1,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        "9 Feb 2024",
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Mengenal Teknik LAMS Andalan Akasia 365mc Body Aesthetics Center, Teknolog"
                      .toCapitalizes(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceDim,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Memiliki bentuk tubuh ideal merupakan idaman banyak orang, tanpa terkecuali terkecuali terkecuali"
                      .toCapitalize(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Container(
            height: 70,
            width: 124,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
