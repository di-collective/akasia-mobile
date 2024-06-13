import '../entities/review_entity.dart';
import '../repositories/ratings_repository.dart';

final class GetMyReviewsUseCase {
  final RatingsRepository ratingsRepository;

  GetMyReviewsUseCase({
    required this.ratingsRepository,
  });

  Future<List<ReviewEntity>> call({
    required int page,
    required int size,
  }) {
    return ratingsRepository.getMyReviews(page: page, size: size);
  }
}
