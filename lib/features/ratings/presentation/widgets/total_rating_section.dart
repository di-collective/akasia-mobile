import 'package:akasia365mc/core/config/asset_path.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class TotalRatingSection extends StatelessWidget {
  final double totalRating;

  const TotalRatingSection({
    super.key,
    required this.totalRating,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colors = context.theme.appColorScheme;
    return Row(
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
          spacing: 8,
          children: [
            SvgPicture.asset(
              AssetIconsPath.icRatingStar,
              colorFilter: ColorFilter.mode(
                colors.primary,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
            Text(
              totalRating.toString(),
              style: textTheme.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ],
    );
  }

  String _ratingLabel(BuildContext context) {
    if (totalRating.inRange(DoubleRange(1, 1.9))) {
      return context.locale.itsNotForMe;
    }
    if (totalRating.inRange(DoubleRange(2, 2.9))) {
      return context.locale.doesNotMeetExpectation;
    }
    if (totalRating.inRange(DoubleRange(3, 3.9))) {
      return context.locale.justOkay;
    }
    if (totalRating.inRange(DoubleRange(4, 4.9))) {
      return context.locale.excellent;
    }
    if (totalRating == 5) {
      return context.locale.magnificent;
    }
    return "";
  }
}
