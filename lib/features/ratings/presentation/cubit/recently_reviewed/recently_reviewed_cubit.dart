import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_recent_reviews_usecase.dart';
import 'recently_reviewed_state.dart';

class RecentlyReviewedCubit extends Cubit<RecentlyReviewedState> {
  final GetRecentReviewsUseCase _getRecentReviewsUseCase;

  RecentlyReviewedCubit({
    required GetRecentReviewsUseCase getRecentReviewsUseCase,
  })  : _getRecentReviewsUseCase = getRecentReviewsUseCase,
        super(RecentlyReviewedStateInitial());

  Future<void> getRecentReviews() async {
    emit(RecentlyReviewedStateLoading());
    final reviews = await _getRecentReviewsUseCase.call();
    emit(RecentlyReviewedStateLoaded(reviews: reviews));
  }
}
