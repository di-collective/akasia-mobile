import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_recent_reviews_usecase.dart';
import 'recently_reviewed_state.dart';

class RecentlyReviewedCubit extends Cubit<RecentlyReviewedState> {
  final GetRecentReviewsUseCase _getRecentReviewsUseCase;

  RecentlyReviewedCubit({
    required GetRecentReviewsUseCase getRecentReviewsUseCase,
  })  : _getRecentReviewsUseCase = getRecentReviewsUseCase,
        super(const RecentlyReviewedState());

  Future<void> onGetRecentReviews() async {
    const size = 5;
    final newReviews = await _getRecentReviewsUseCase.call(
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
}
