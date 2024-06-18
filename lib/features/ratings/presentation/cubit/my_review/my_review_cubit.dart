import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_reviews_usecase.dart';
import 'my_review_state.dart';

class MyReviewCubit extends Cubit<MyReviewState> {
  final GetMyReviewsUseCase _getMyReviewsUseCase;

  MyReviewCubit({
    required GetMyReviewsUseCase getMyReviewsUseCase,
  })  : _getMyReviewsUseCase = getMyReviewsUseCase,
        super(const MyReviewState());

  Future<void> onGetMyReviews() async {
    const size = 5;
    final newReviews = await _getMyReviewsUseCase.call(
      page: state.nextPage,
      size: size,
    );
    emit(
      state.copy(
        reviews: [
          ...?state.reviews,
          ...newReviews,
        ],
        nextPage: state.nextPage + 1,
        isLastPage: newReviews.length < size,
      ),
    );
  }

  Future<bool> onDeleteReview(String id) async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        emit(
          state.copy(
            reviews: state.reviews
                ?.whereNot(
                  (e) => e.id == id,
                )
                .toList(),
          ),
        );
        return true;
      },
    );
  }
}
