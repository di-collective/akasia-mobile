import 'dart:math';

import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/ratings_repository.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  @override
  Future<List<ReviewEntity>> getMyReviews() {
    return Future.value(_generateFakeReviews(5, false, false));
  }

  @override
  Future<List<ReviewEntity>> getRecentReviews() {
    return Future.value(_generateFakeReviews(5, false, true));
  }
}

List<ReviewEntity> _generateFakeReviews(int size, bool emptyReview, bool randomUser) {
  final random = Random();
  return List<ReviewEntity>.generate(
    size,
    (index) => ReviewEntity(
      id: index.toString(),
      userName: randomUser ? 'User Name $index' : 'My User Name',
      userEffectivenessRating: index == 0 && emptyReview ? null : _doubleInRange(random, 2.5, 5),
      userValueForMoneyRating: index == 0 && emptyReview ? null : _doubleInRange(random, 2.5, 5),
      userReview: index == 0 && emptyReview
          ? null
          : 'LAMS really works on me. I lost 5kgs in total. '
              'Lingkar lengan berkurang 6 cm dan lingkar paha 7 cm. '
              'Treatment ini cocok banget buat menghilangkan fat stubborn '
              'karena langsung tepat di sasaran. Prosedurnya pun aman karena '
              'kita hanya dibius lokal. Thank you Akasia365mc Indonesia!',
      treatmentName: 'Treatment',
      treatmentDescription: 'Description of Treatment',
      treatmentAverageRating: _doubleInRange(random, 2.5, 5),
      treatmentTotalReviews: 2345,
      updatedAt: "1mo",
    ),
  );
}

double _doubleInRange(Random source, num start, num end) {
  final value = source.nextDouble() * (end - start) + start;
  return value.roundToDouble();
}
