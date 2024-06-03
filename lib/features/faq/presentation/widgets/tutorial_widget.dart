import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../data/models/faq_model.dart';

class TutorialsWidget extends StatelessWidget {
  final FaqModel faq;

  const TutorialsWidget({
    super.key,
    required this.faq,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ListView.separated(
      itemCount: faq.faqDetails?.length ?? 0,
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingHorizontal,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 32,
        );
      },
      itemBuilder: (context, index) {
        final detail = faq.faqDetails![index];

        return Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AssetIconsPath.icArrowRightCircle,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    detail.title ?? '',
                    maxLines: 3,
                    style: textTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceDim,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              detail.description ?? '',
              maxLines: 20,
              style: textTheme.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}
