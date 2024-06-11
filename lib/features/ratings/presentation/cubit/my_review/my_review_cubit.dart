import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_reviews_usecase.dart';
import 'my_review_state.dart';

class MyReviewCubit extends Cubit<MyReviewState> {
  final GetMyReviewsUseCase _getMyReviewsUseCase;

  MyReviewCubit({
    required GetMyReviewsUseCase getMyReviewsUseCase,
  })  : _getMyReviewsUseCase = getMyReviewsUseCase,
        super(MyReviewStateInitial());

  Future<void> onGetMyReviews() async {
    emit(MyReviewStateLoading());
    final reviews = await _getMyReviewsUseCase.call();
    emit(MyReviewStateLoaded(reviews: reviews));
  }

  Future<void> onDeleteReview(String id) async {
    final currentState = (state as MyReviewStateLoaded);
    emit(
      currentState.copy(
        reviews: currentState.reviews.whereNot((e) => e.id == id).toList(),
      ),
    );
  }
}
