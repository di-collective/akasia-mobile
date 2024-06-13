import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'ratings_bar.dart';

class ReviewProductCard extends StatelessWidget {
  final String name, description;
  final double averageRating;
  final int maxRatingScore, totalReviews;

  const ReviewProductCard({
    super.key,
    required this.name,
    required this.description,
    required this.averageRating,
    required this.maxRatingScore,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlinePrimary,
          )),
      child: IntrinsicHeight(
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: colorScheme.surfaceDim,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingsBar(
                          initialRating: averageRating,
                          maxRatingScore: maxRatingScore,
                          itemSize: 12,
                          itemSpacing: 2,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          averageRating.toString(),
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '($totalReviews)',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
