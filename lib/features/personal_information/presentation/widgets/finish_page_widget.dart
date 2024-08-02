import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/dividers/title_divider_widget.dart';

class FinishPageWidget extends StatelessWidget {
  final String startWeight;
  final String weightGoal;

  const FinishPageWidget({
    super.key,
    required this.startWeight,
    required this.weightGoal,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.06,
          ),
          Text(
            context.locale.wePredictThatYouWillBe.toCapitalizes(),
            style: textTheme.bodyLarge.copyWith(
              color: colorScheme.onSurfaceDim,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${weightGoal}kg",
                  style: TextStyle(
                    color: colorScheme.primary,
                  ),
                ),
                const TextSpan(text: " by "),
                TextSpan(
                  text: "April 9",
                  style: TextStyle(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TitleDividerWidget(
            color: colorScheme.onSurfaceDim,
            width: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              SvgPicture.asset(
                _chartPath,
                width: context.width,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today',
                      style: textTheme.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "April 9",
                      style: textTheme.bodyLarge.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            context.locale.yourPlanIsReady.toCapitalizes(),
            style: textTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceDim,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingHorizontal,
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.locale.yourBudgetCalories("1.478"),
                  ),
                  const TextSpan(text: ". "),
                  TextSpan(
                    text: context.locale.ifYourConsistenlyEatAnAverage("1.478"),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              maxLines: 5,
              textAlign: TextAlign.center,
              style: textTheme.labelLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  String get _chartPath {
    final start = startWeight.dynamicToDouble;
    final goal = weightGoal.dynamicToDouble;

    if (start == null || goal == null) {
      return AssetImagesPath.dietChartUp;
    }

    if (start > goal) {
      return AssetImagesPath.dietChartDown;
    }

    return AssetImagesPath.dietChartUp;
  }
}
