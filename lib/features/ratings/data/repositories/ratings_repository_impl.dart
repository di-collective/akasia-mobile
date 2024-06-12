import 'dart:math';

import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/ratings_repository.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  @override
  Future<List<ReviewEntity>> getMyReviews({
    required int page,
    required int size,
  }) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => _FakeRatingsData().generateFakeReviews(
        page: page,
        size: size,
        totalSize: 13,
        emptyReview: true,
      ),
    );
  }

  @override
  Future<List<ReviewEntity>> getRecentReviews({
    required int page,
    required int size,
  }) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => _FakeRatingsData().generateFakeReviews(
        page: page,
        size: size,
        totalSize: 53,
        randomUserName: true,
      ),
    );
  }
}

class _FakeRatingsData {
  List<ReviewEntity> generateFakeReviews({
    required int page,
    required int size,
    required int totalSize,
    bool emptyReview = false,
    bool randomUserName = false,
  }) {
    final random = Random();
    final generatedSize = page * size;
    final diff = totalSize - generatedSize;
    final length = diff < size ? diff : size;
    return generatedSize < totalSize
        ? List<ReviewEntity>.generate(
            length,
            (index) {
              final id = generatedSize + index;
              return ReviewEntity(
                id: id.toString(),
                userName: randomUserName ? 'User Name ${id + 1}' : 'My User Name',
                userEffectivenessRating:
                    id == 0 && emptyReview ? null : _doubleInRange(random, 2.5, 5),
                userValueForMoneyRating:
                    id == 0 && emptyReview ? null : _doubleInRange(random, 2.5, 5),
                userReview: id == 0 && emptyReview ? null : _lorem(index),
                treatmentName: 'Treatment',
                treatmentDescription: 'Description of Treatment',
                treatmentAverageRating: _doubleInRange(random, 2.5, 5),
                treatmentTotalReviews: _doubleInRange(random, 2000, 5000).toInt(),
                updatedAt: "1mo",
              );
            },
          )
        : List.empty();
  }

  double _doubleInRange(Random source, num start, num end) {
    final value = source.nextDouble() * (end - start) + start;
    return value.roundToDouble();
  }

  String _lorem(int num) => num.isEven
      ? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
      : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
}
