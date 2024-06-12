import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/ratings_bar.dart';
import '../widgets/review_product_card.dart';

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
  double effectivenessRating = 0;
  double valueForMoneyRating = 0;

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

  void _onUpdateEffectivenessRating(double value) {
    setState(() {
      effectivenessRating = value;
    });
  }

  void _onUpdateValueForMoneyRating(double value) {
    setState(() {
      valueForMoneyRating = value;
    });
  }

  void _onNextPage() {}
}

class _GiveRatingBar extends StatelessWidget {
  final String label;
  final double initialRating;
  final Function(double rating) onRatingChange;

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
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
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
            initialRating: initialRating,
            minRating: 1,
            itemSize: 32,
            allowHalfRating: false,
            onValueChange: onRatingChange,
          )
        ],
      ),
    );
  }
}

class _GiveRatingBottomSection extends StatelessWidget {
  final double effectivenessRating, valueForMoneyRating;
  final Function() onNext;

  const _GiveRatingBottomSection({
    required this.effectivenessRating,
    required this.valueForMoneyRating,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 4,
                        direction: Axis.vertical,
                        children: [
                          Text(
                            context.locale.yourRating,
                            style: textTheme.labelMedium.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          Text(
                            _ratingLabel(context),
                            style: textTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 30,
                            color: colors.primary,
                          ),
                          Text(
                            _totalRating.toString(),
                            style: textTheme.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ],
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

  double get _totalRating => (effectivenessRating + valueForMoneyRating) / 2;

  String _ratingLabel(BuildContext context) {
    if (_totalRating.inRange(DoubleRange(1, 1.9))) {
      return context.locale.itsNotForMe;
    }
    if (_totalRating.inRange(DoubleRange(2, 2.9))) {
      return context.locale.doesNotMeetExpectation;
    }
    if (_totalRating.inRange(DoubleRange(3, 3.9))) {
      return context.locale.justOkay;
    }
    if (_totalRating.inRange(DoubleRange(4, 4.9))) {
      return context.locale.excellent;
    }
    if (_totalRating == 5) {
      return context.locale.magnificent;
    }
    return "";
  }
}
