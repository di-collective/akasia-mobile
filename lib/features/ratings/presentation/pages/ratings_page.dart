import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/nav_bar/nav_bar_cubit.dart';
import '../cubit/nav_bar/nav_bar_state.dart';
import '../widgets/my_review_section.dart';
import '../widgets/nav_bar_section.dart';
import '../widgets/recently_reviewed_section.dart';

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
  @override
  Widget build(BuildContext context) {
    final navBarCubit = BlocProvider.of<NavBarCubit>(context);

    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, navBarState) {
        return Scaffold(
          appBar: AppBar(
            // hardcoded
            title: Text(context.locale.ratings),
          ),
          body: SafeArea(
            child: Column(
              children: [
                NavBarSection(
                  items: NavBarItem.values.toList(),
                  selectedItem: navBarState.selectedItem,
                  onUpdateSelectedItem: navBarCubit.onUpdateSelectedItem,
                ),
                Expanded(
                  child: switch (navBarState.selectedItem) {
                    NavBarItem.recentlyReviewed => const RecentlyReviewedSection(),
                    NavBarItem.myReview => const MyReviewSection()
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
