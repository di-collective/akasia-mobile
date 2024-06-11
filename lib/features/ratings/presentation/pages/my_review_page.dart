import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/widget/dialogs/snack_bar.dart';
import '../cubit/my_review/my_review_cubit.dart';
import '../cubit/my_review/my_review_state.dart';
import '../widgets/review_empty_section.dart';
import '../widgets/review_item_widget.dart';
import '../widgets/review_list_section.dart';

class MyReviewPage extends StatefulWidget {
  final double? topPadding;

  const MyReviewPage({
    super.key,
    this.topPadding,
  });

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyReviewCubit, MyReviewState>(
      builder: (context, state) {
        switch (state) {
          case MyReviewStateLoaded():
            if (state.reviews.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: widget.topPadding ?? 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReviewItemBanner(),
                    Expanded(
                      child: ReviewEmptySection(
                        context.locale.thereAreNoPost,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return ReviewListSection(
                topPadding: widget.topPadding,
                items: <ReviewItemWidget>[
                  const ReviewItemBanner(),
                  ...state.reviews.map(
                    (review) => ReviewItemCard(
                      review,
                      onDelete: (id) => _onDeleteReview(id),
                    ),
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
    final myReviewCubit = context.cubit<MyReviewCubit>();
    if (myReviewCubit.state is MyReviewStateLoaded || myReviewCubit.state is MyReviewStateLoading) {
      return;
    }
    myReviewCubit.onGetMyReviews();
  }

  void _onDeleteReview(String id) async {
    await context.cubit<MyReviewCubit>().onDeleteReview(id);
    AppSnackBar.success(
      context,
      message: context.locale.theReviewSuccessfullyDeleted,
    );
  }
}
