import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/my_review/my_review_cubit.dart';
import '../cubit/nav_bar/nav_bar_cubit.dart';
import '../cubit/nav_bar/nav_bar_state.dart';
import '../cubit/recently_reviewed/recently_reviewed_cubit.dart';
import '../widgets/nav_bar_section.dart';
import 'my_review_page.dart';
import 'recently_reviewed_page.dart';

class RatingsPage extends StatelessWidget {
  const RatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NavBarCubit>(),
      child: const _Page(),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  late PageController _pageController;
  double? _navBarHeight;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const navBarItems = NavBarItem.values;

    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, navBarState) {
        return Scaffold(
          appBar: AppBar(
            // hardcoded
            title: Text(context.locale.ratings),
          ),
          body: Stack(
            children: [
              _RatingsPageView(
                navBarHeight: _navBarHeight,
                pageController: _pageController,
                navBarItems: navBarItems,
                onUpdateSelectedItem: _onUpdateSelectedItem,
              ),
              NavBarSection(
                items: navBarItems,
                selectedItem: navBarState.selectedItem,
                onTap: _onMoveToPage,
                onHeightMeasured: _onSetNavBarHeight,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSetNavBarHeight(double height) {
    setState(() {
      _navBarHeight = height;
    });
  }

  void _onMoveToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _onUpdateSelectedItem(NavBarItem item) {
    BlocProvider.of<NavBarCubit>(context).onUpdateSelectedItem(item);
  }
}

class _RatingsPageView extends StatefulWidget {
  final double? navBarHeight;
  final PageController pageController;
  final List<NavBarItem> navBarItems;
  final Function(NavBarItem item) onUpdateSelectedItem;

  const _RatingsPageView({
    this.navBarHeight,
    required this.pageController,
    required this.navBarItems,
    required this.onUpdateSelectedItem,
  });

  @override
  State<_RatingsPageView> createState() => _RatingsPageViewState();
}

class _RatingsPageViewState extends State<_RatingsPageView> {
  @override
  Widget build(BuildContext context) {
    final navBarItems = widget.navBarItems;
    final pageController = widget.pageController;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MyReviewCubit>()),
        BlocProvider(create: (_) => sl<RecentlyReviewedCubit>())
      ],
      child: PageView.builder(
        controller: pageController,
        itemCount: navBarItems.length,
        onPageChanged: (index) {
          widget.onUpdateSelectedItem(navBarItems[index]);
        },
        itemBuilder: (ctx, index) {
          final item = navBarItems[index];
          return switch (item) {
            NavBarItem.recentlyReviewed => RecentlyReviewedPage(
                topPadding: widget.navBarHeight,
              ),
            NavBarItem.myReview => MyReviewPage(
                topPadding: widget.navBarHeight,
              ),
          };
        },
      ),
    );
  }
}
