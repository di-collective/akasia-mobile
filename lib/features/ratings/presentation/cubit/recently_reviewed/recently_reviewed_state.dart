import 'package:equatable/equatable.dart';

import '../../../domain/entities/review_entity.dart';

class RecentlyReviewedState extends Equatable {
  final List<ReviewEntity>? reviews;
  final int nextPage;
  final bool isLastPage;

  const RecentlyReviewedState({
    this.reviews,
    this.nextPage = 0,
    this.isLastPage = false,
  });

  RecentlyReviewedState copy({
    List<ReviewEntity>? reviews,
    int? nextPage,
    bool? isLastPage,
  }) {
    return RecentlyReviewedState(
      reviews: reviews ?? this.reviews,
      nextPage: nextPage ?? this.nextPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [
        reviews,
        nextPage,
        isLastPage,
      ];
}
