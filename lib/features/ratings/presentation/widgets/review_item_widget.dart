import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/icon_button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../domain/entities/review_entity.dart';
import 'ratings_bar.dart';
import 'review_product_card.dart';

sealed class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({super.key});
}

class ReviewItemBanner extends ReviewItemWidget {
  const ReviewItemBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.letsGoWriteAReview,
                    style: textTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locale.shareYourExperienceEveryTimeYouHaveTreatmentAt_ +
                        locale.appName,
                    style: textTheme.labelMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: colorScheme.surfaceDim,
              ))
        ],
      ),
    );
  }
}

class ReviewItemTitle extends ReviewItemWidget {
  final String title;

  const ReviewItemTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ) +
          const EdgeInsets.only(
            top: 24,
            bottom: 16,
          ),
      child: Text(
        title,
        style: textTheme.headlineSmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        maxLines: 2,
      ),
    );
  }
}

class ReviewItemCard extends ReviewItemWidget {
  final ReviewEntity review;
  final Function(String id)? onDelete;
  final Function(ReviewEntity review)? onWriteReview;
  static const _maxRatingScore = 5;

  const ReviewItemCard(
    this.review, {
    super.key,
    this.onDelete,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerBright,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlinePrimary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewItemCardHeader(
            avatarUrl: null,
            userName: review.userName,
            date: review.updatedAt,
          ),
          _ReviewItemCardRatingScore(
            userEffectivenessRating: review.userEffectivenessRating,
            userValueForMoneyRating: review.userValueForMoneyRating,
            maxRatingScore: _maxRatingScore,
          ),
          ReviewProductCard(
            name: review.treatmentName,
            description: review.treatmentDescription,
            averageRating: review.treatmentAverageRating,
            totalReviews: review.treatmentTotalReviews,
            maxRatingScore: _maxRatingScore,
          ),
          if (review.userReview != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                review.userReview ?? '',
                maxLines: 6,
                style: textTheme.labelMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
            if (onDelete != null) ...[
              Align(
                alignment: Alignment.centerRight,
                child: IconButtonWidget(
                  icon: SvgPicture.asset(
                    AssetIconsPath.icTrash,
                    theme: SvgTheme(
                      currentColor: colors.onSurface,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    onDelete?.call(review.id);
                  },
                ),
              )
            ],
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  onWriteReview?.call(review);
                },
                child: Text(
                  context.locale.writeReview,
                  style: textTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _ReviewItemCardHeader extends StatelessWidget {
  final String? avatarUrl;
  final String userName, date;

  const _ReviewItemCardHeader({
    this.avatarUrl,
    required this.userName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NetworkImageWidget(
          imageUrl: avatarUrl,
          size: const Size(
            40,
            40,
          ),
          shapeBorder: const CircleBorder(),
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            userName,
            style: textTheme.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          date,
          style: textTheme.bodySmall.copyWith(
            color: colorScheme.onSurfaceBright,
          ),
        ),
      ],
    );
  }
}

class _ReviewItemCardRatingScore extends StatefulWidget {
  final int? userEffectivenessRating, userValueForMoneyRating;
  final int maxRatingScore;

  const _ReviewItemCardRatingScore({
    this.userEffectivenessRating,
    this.userValueForMoneyRating,
    required this.maxRatingScore,
  });

  @override
  State<_ReviewItemCardRatingScore> createState() =>
      _ReviewItemCardRatingScoreState();
}

class _ReviewItemCardRatingScoreState
    extends State<_ReviewItemCardRatingScore> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;
    final locale = context.locale;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_userRating != null) {
                _isExpanded = !_isExpanded;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingsBar(
                  initialRating: _userRating,
                  maxRatingScore: widget.maxRatingScore,
                  itemSize: 16,
                  itemSpacing: 4,
                ),
                if (_userRating != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    _userRating.toString(),
                    style: textTheme.labelMedium,
                  ),
                  const SizedBox(width: 2),
                  RotatedBox(
                    quarterTurns: _isExpanded ? 0 : 2,
                    child: SvgPicture.asset(
                      AssetIconsPath.icChevronUp,
                      theme: SvgTheme(
                        currentColor: colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
        if (_userRating != null) ...[
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _ratingScoreDetail(
                                score: widget.userEffectivenessRating,
                                maxScore: widget.maxRatingScore,
                                name: locale.effectiveness,
                              ),
                            ),
                            Expanded(
                              child: _ratingScoreDetail(
                                score: widget.userValueForMoneyRating,
                                maxScore: widget.maxRatingScore,
                                name: locale.valueForMoney,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _ratingDetail(
                                title: locale.recommended,
                                value: 'Yes',
                              ),
                            ),
                            Expanded(
                              child: _ratingDetail(
                                title: locale.usagePeriod,
                                value: '6 Months - 1 Year',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ],
    );
  }

  double? get _userRating {
    final rating1 = widget.userEffectivenessRating;
    final rating2 = widget.userValueForMoneyRating;
    if (rating1 != null && rating2 != null) {
      return (rating1 + rating2) / 2;
    }
    return null;
  }

  Widget _ratingScoreDetail({
    required int? score,
    required int maxScore,
    required String name,
  }) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$score/$maxScore',
          style: textTheme.labelMedium.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _ratingDetail({
    required String title,
    required String value,
  }) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelMedium,
        ),
        const SizedBox(width: 2),
        Text(
          value,
          style: textTheme.labelMedium.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
