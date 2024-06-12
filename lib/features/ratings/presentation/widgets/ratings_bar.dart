import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class RatingsBar extends StatelessWidget {
  final double? initialRating, minRating, itemSize;
  final int? maxRatingScore;
  final Function(double rating)? onValueChange;
  final bool? allowHalfRating;

  const RatingsBar({
    super.key,
    this.initialRating,
    this.minRating,
    this.maxRatingScore,
    this.itemSize,
    this.onValueChange,
    this.allowHalfRating,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final itemSize = this.itemSize ?? 16;
    return RatingBar.builder(
      initialRating: initialRating ?? 0.0,
      minRating: minRating ?? 0.0,
      allowHalfRating: allowHalfRating ?? true,
      glow: false,
      itemCount: maxRatingScore ?? 5,
      itemSize: itemSize * 4 / 3,
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
