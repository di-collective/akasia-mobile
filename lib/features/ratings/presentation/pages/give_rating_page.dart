import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/ratings_bar.dart';
import '../widgets/review_product_card.dart';
import '../widgets/total_rating_section.dart';
import 'write_review_page.dart';

class GiveRatingPageArgs {
  final ReviewEntity review;

  const GiveRatingPageArgs({required this.review});
}

class GiveRatingPage<T> extends StatefulWidget {
  final T? args;

  const GiveRatingPage({
    super.key,
    this.args,
  });

  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<GiveRatingPage> {
  ReviewEntity? _review;
  int effectivenessRating = 0;
  int valueForMoneyRating = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _review =
          widget.args is GiveRatingPageArgs ? (widget.args as GiveRatingPageArgs).review : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final review = _review;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.giveRating),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (review != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ReviewProductCard(
                      name: review.treatmentName,
                      description: review.treatmentDescription,
                      averageRating: review.treatmentAverageRating,
                      maxRatingScore: 5,
                      totalReviews: review.treatmentTotalReviews,
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.howDoYouRateThisTreatment,
                        style: textTheme.titleMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      _GiveRatingBar(
                        label: context.locale.effectiveness,
                        initialRating: effectivenessRating,
                        onRatingChange: _onUpdateEffectivenessRating,
                      ),
                      _GiveRatingBar(
                        label: context.locale.valueForMoney,
                        initialRating: valueForMoneyRating,
                        onRatingChange: _onUpdateValueForMoneyRating,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _GiveRatingBottomSection(
            effectivenessRating: effectivenessRating,
            valueForMoneyRating: valueForMoneyRating,
            onNext: _onNextPage,
          ),
        ],
      ),
    );
  }

  void _onUpdateEffectivenessRating(int value) {
    setState(() {
      effectivenessRating = value;
    });
  }

  void _onUpdateValueForMoneyRating(int value) {
    setState(() {
      valueForMoneyRating = value;
    });
  }

  void _onNextPage() {
    final reviewId = _review?.id;
    if (reviewId != null) {
      context.goNamed(
        AppRoute.writeReview.name,
        extra: WriteReviewPageArgs(
          reviewId: reviewId,
          effectivenessRating: effectivenessRating,
          valueForMoneyRating: valueForMoneyRating,
        ),
      );
    }
  }
}

class _GiveRatingBar extends StatelessWidget {
  final String label;
  final int initialRating;
  final Function(int rating) onRatingChange;

  const _GiveRatingBar({
    required this.label,
    required this.initialRating,
    required this.onRatingChange,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colors = context.theme.appColorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.outlineBright,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.labelLarge,
          ),
          RatingsBar(
            initialRating: initialRating.toDouble(),
            minRating: 1,
            itemSize: 32,
            itemSpacing: 8,
            allowHalfRating: false,
            onValueChange: (value) {
              onRatingChange(value.toInt());
            },
          )
        ],
      ),
    );
  }
}

class _GiveRatingBottomSection extends StatelessWidget {
  final int effectivenessRating, valueForMoneyRating;
  final Function() onNext;

  const _GiveRatingBottomSection({
    required this.effectivenessRating,
    required this.valueForMoneyRating,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: effectivenessRating >= 1 && valueForMoneyRating >= 1
          ? Container(
              padding: const EdgeInsets.all(16) +
                  EdgeInsets.only(
                    bottom: context.mediaQuery.padding.bottom,
                  ),
              decoration: BoxDecoration(
                color: colors.surfaceContainerBright,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TotalRatingSection(
                    totalRating: _totalRating,
                  ),
                  const SizedBox(height: 16),
                  ButtonWidget(
                    text: context.locale.next,
                    onTap: onNext,
                  )
                ],
              ),
            )
          : const SizedBox(width: double.infinity),
    );
  }

  double get _totalRating => (effectivenessRating.toDouble() + valueForMoneyRating.toDouble()) / 2;
}
