import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../cubit/recently_reviewed/recently_reviewed_cubit.dart';
import '../cubit/recently_reviewed/recently_reviewed_state.dart';
import '../widgets/review_empty_section.dart';
import '../widgets/review_item_widget.dart';
import '../widgets/review_list_section.dart';

class RecentlyReviewedPage extends StatefulWidget {
  final double? topPadding;

  const RecentlyReviewedPage({
    super.key,
    this.topPadding,
  });

  @override
  State<RecentlyReviewedPage> createState() => _RecentlyReviewedPageState();
}

class _RecentlyReviewedPageState extends State<RecentlyReviewedPage> {
  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentlyReviewedCubit, RecentlyReviewedState>(
      builder: (context, state) {
        switch (state) {
          case RecentlyReviewedStateLoaded():
            if (state.reviews.isEmpty) {
              return ReviewEmptySection(context.locale.thereAreNoPost);
            } else {
              return ReviewListSection(
                topPadding: widget.topPadding,
                items: <ReviewItemWidget>[
                  ReviewItemTitle(title: context.locale.recentlyReviewed),
                  ...state.reviews.map(
                    (review) => ReviewItemCard(review),
                  ),
                ],
              );
            }
          default:
            //todo: loading state
            return Container();
        }
      },
    );
  }

  void _onInit() {
    final recentlyReviewedCubit = BlocProvider.of<RecentlyReviewedCubit>(context);
    final state = recentlyReviewedCubit.state;
    if (state is RecentlyReviewedStateLoaded || state is RecentlyReviewedStateLoading) {
      return;
    }
    recentlyReviewedCubit.getRecentReviews();
  }
}
