import '../entities/review_entity.dart';
import '../repositories/ratings_repository.dart';

final class GetRecentReviewsUseCase {
  final RatingsRepository ratingsRepository;

  GetRecentReviewsUseCase({
    required this.ratingsRepository,
  });

  Future<List<ReviewEntity>> call() => ratingsRepository.getRecentReviews();
}
