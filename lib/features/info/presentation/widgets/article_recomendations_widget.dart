import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'recomendation_item_widget.dart';

class ArticleRecomendationsWidget extends StatefulWidget {
  const ArticleRecomendationsWidget({super.key});

  @override
  State<ArticleRecomendationsWidget> createState() =>
      _ArticleRecomendationsWidgetState();
}

class _ArticleRecomendationsWidgetState
    extends State<ArticleRecomendationsWidget> {
  int _currentPage = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _pageController = PageController(
      initialPage: _currentPage,
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
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: context.paddingHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.articleRecomendations,
                style: textTheme.titleMedium.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _onLeftArticlePage,
                    icon: SvgPicture.asset(
                      AssetIconsPath.icChevronLeft,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurfaceDim,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _onRightArticlePage,
                    icon: SvgPicture.asset(
                      AssetIconsPath.icChevronRight,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurfaceDim,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: 5,
            controller: _pageController,
            padEnds: false,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? context.paddingHorizontal : 12,
                  right: index == 4 ? context.paddingHorizontal : 0,
                ),
                child: GestureDetector(
                  onTap: _onArticle,
                  child: const RecomendationItemWidget(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onLeftArticlePage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onRightArticlePage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onArticle() {
    // TODO: Implement this method
  }
}
