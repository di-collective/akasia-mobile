import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class NutritionInformationWidget extends StatelessWidget {
  const NutritionInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: 0.99,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.outlineBright,
                          ),
                          strokeWidth: 16,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: 0.6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                          strokeWidth: 16,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "460",
                              maxLines: 1,
                              style: textTheme.titleLarge.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "/1.478",
                              maxLines: 1,
                              style: textTheme.bodySmall.copyWith(
                                color: colorScheme.onSurfaceBright,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.nutritionInformation,
                      maxLines: 2,
                      style: textTheme.labelLarge.copyWith(
                        color: colorScheme.onSurfaceDim,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        _ItemWidget(
                          title: context.locale.carbo,
                          value: "338",
                        ),
                        _ItemWidget(
                          title: context.locale.fat,
                          value: "26%",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        _ItemWidget(
                          title: context.locale.protein,
                          value: "56%",
                        ),
                        _ItemWidget(
                          title: context.locale.sugar,
                          value: "18%",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset(
                AssetIconsPath.icFire,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${context.locale.trackDailyCalories}!",
                maxLines: 3,
                style: textTheme.labelMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const _ItemWidget({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      width: context.width * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: textTheme.bodySmall.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            maxLines: 3,
            style: textTheme.labelMedium.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
