import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'topic_recomendation_item_widget.dart';

class TopicRecomendationsWidget extends StatefulWidget {
  const TopicRecomendationsWidget({super.key});

  @override
  State<TopicRecomendationsWidget> createState() =>
      _TopicRecomendationsWidgetState();
}

class _TopicRecomendationsWidgetState extends State<TopicRecomendationsWidget> {
  String _selectedCategory = mockTopicRecomendationCategories.first;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: Text(
            context.locale.topicRecommendations,
            style: textTheme.titleMedium.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 11,
            children: mockTopicRecomendationCategories
                .map(
                  (category) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedCategory == category
                            ? colorScheme.primary
                            : colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        category,
                        style: textTheme.labelMedium.copyWith(
                          color: _selectedCategory == category
                              ? colorScheme.surfaceContainerBright
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ListView.separated(
          itemCount: 5,
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 16,
            );
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: _onTopicRecomendation,
              child: const TopicRecomendationItemWidget(),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: _onSeeAll,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.locale.seeAll.toCapitalizes(),
                style: textTheme.bodyMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                AssetIconsPath.icArrowRight,
                colorFilter: ColorFilter.mode(
                  colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onSeeAll() {
    // TODO: Implement this method
  }

  void _onTopicRecomendation() {
    // TODO: Implement this method
  }
}

final List<String> mockTopicRecomendationCategories = [
  'Kesehatan',
  'Kecantikan',
  'Bisnis',
  'Pendidikan',
  'Teknologi',
  'Olahraga',
];
