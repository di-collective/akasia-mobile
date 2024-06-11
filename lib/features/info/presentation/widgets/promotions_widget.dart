import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'promotion_item_widget.dart';

class PromotionsWidget extends StatefulWidget {
  const PromotionsWidget({super.key});

  @override
  State<PromotionsWidget> createState() => _PromotionsWidgetState();
}

class _PromotionsWidgetState extends State<PromotionsWidget> {
  int _currentPromotionPage = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _pageController = PageController(
      initialPage: _currentPromotionPage,
      viewportFraction: 0.9,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.attractivePromotionForYou,
                style: textTheme.titleMedium.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: _onViewAllPromotion,
                child: Text(
                  context.locale.seeAll,
                  style: textTheme.labelLarge.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 147,
          child: PageView.builder(
            itemCount: 5,
            controller: _pageController,
            padEnds: false,
            onPageChanged: (index) {
              setState(() {
                _currentPromotionPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? context.paddingHorizontal : 12,
                  right: index == 4 ? context.paddingHorizontal : 0,
                ),
                child: GestureDetector(
                  onTap: _onPromotion,
                  child: const PromotionItemWidget(),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: AnimatedSmoothIndicator(
            activeIndex: _currentPromotionPage,
            count: 5,
            effect: ExpandingDotsEffect(
              dotColor: colorScheme.surfaceBright,
              activeDotColor: colorScheme.primary,
              dotWidth: 8,
              dotHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  void _onViewAllPromotion() {
    // TODO: Implement this method
  }

  void _onPromotion() {
    // TODO: Implement this method
  }
}
