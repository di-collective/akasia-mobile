import '../entities/review_entity.dart';

abstract class RatingsRepository {
  Future<List<ReviewEntity>> getMyReviews();

  Future<List<ReviewEntity>> getRecentReviews();
}
