import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class RatingsBar extends StatelessWidget {
  final double? initialRating, minRating, itemSize;
  final int? maxRatingScore;
  final Function(double rating)? onValueChange;
  final bool? allowHalfRating;
  final double? itemSpacing;

  const RatingsBar({
    super.key,
    this.initialRating,
    this.minRating,
    this.maxRatingScore,
    this.itemSize,
    this.onValueChange,
    this.allowHalfRating,
    this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final itemCount = maxRatingScore ?? 5;
    return RatingBar.builder(
      initialRating: initialRating ?? 0.0,
      minRating: minRating ?? 0.0,
      allowHalfRating: allowHalfRating ?? true,
      glow: false,
      itemCount: itemCount,
      itemSize: itemSize ?? 16,
      itemPadding: EdgeInsets.only(right: itemSpacing ?? 0),
      unratedColor: colorScheme.outline,
      itemBuilder: (context, index) => SvgPicture.asset(
        AssetIconsPath.icRatingStar,
        colorFilter: ColorFilter.mode(
          colorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
      onRatingUpdate: (rating) {
        onValueChange?.call(rating);
      },
      ignoreGestures: onValueChange == null,
    );
  }
}
