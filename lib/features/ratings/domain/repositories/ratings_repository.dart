import '../entities/review_entity.dart';

abstract class RatingsRepository {
  Future<List<ReviewEntity>> getMyReviews({
    required int page,
    required int size,
  });

  Future<List<ReviewEntity>> getRecentReviews({
    required int page,
    required int size,
  });
}
