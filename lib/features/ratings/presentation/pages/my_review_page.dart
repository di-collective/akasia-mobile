import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../../domain/entities/review_entity.dart';
import '../cubit/my_review/my_review_cubit.dart';
import '../cubit/my_review/my_review_state.dart';
import '../widgets/review_empty_section.dart';
import '../widgets/review_item_widget.dart';
import '../widgets/review_list_section.dart';
import 'give_rating_page.dart';

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
    super.initState();
    _onFetchNewReviews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyReviewCubit, MyReviewState>(
      builder: (context, state) {
        final reviews = state.reviews;

        if (reviews == null) {
          //todo: loading state
          return Container();
        }

        if (reviews.isEmpty) {
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
            onFetchNewReviews: _onFetchNewReviews,
            items: <ReviewItemWidget>[
              const ReviewItemBanner(),
              ...reviews.map(
                (review) => ReviewItemCard(
                  review,
                  onDelete: (id) => _onDeleteReview(id),
                  onWriteReview: _onWriteReview,
                ),
              ),
            ],
            nextPage: state.nextPage,
            isLastPage: state.isLastPage,
          );
        }
      },
    );
  }

  Future<void> _onFetchNewReviews() async =>
      context.cubit<MyReviewCubit>().onGetMyReviews();

  Future<void> _onDeleteReview(String id) async {
    final locale = context.locale;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmationDialogWidget(
          title: locale.deleteReview,
          description: locale.areYouSureToDeleteThisReview,
          confirmText: locale.delete,
          cancelText: locale.cancel,
        );
      },
    );

    if (shouldDelete != true) return;

    final isDeleted = await context.cubit<MyReviewCubit>().onDeleteReview(id);

    if (isDeleted) {
      context.showSuccessToast(
        message: context.locale.theReviewSuccessfullyDeleted,
      );
    }
  }

  void _onWriteReview(ReviewEntity review) {
    context.goNamed(
      AppRoute.giveRating.name,
      extra: GiveRatingPageArgs(review: review),
    );
  }
}
