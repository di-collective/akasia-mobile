import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class RatingsBar extends StatelessWidget {
  final double? initialRating;
  final int? maxRatingScore;
  final double? itemSize;
  final Function(double rating)? onValueChange;

  const RatingsBar({
    super.key,
    this.initialRating,
    this.maxRatingScore,
    this.itemSize,
    this.onValueChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    return RatingBar.builder(
      initialRating: initialRating ?? 0.0,
      allowHalfRating: true,
      glow: false,
      itemCount: maxRatingScore ?? 5,
      itemSize: itemSize ?? 16,
      unratedColor: colorScheme.outline,
      itemBuilder: (context, _) => Icon(
        Icons.star_rounded,
        color: colorScheme.primary,
      ),
      onRatingUpdate: (rating) {
        onValueChange?.call(rating);
      },
      ignoreGestures: onValueChange == null,
    );
  }
}
