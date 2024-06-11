import 'package:equatable/equatable.dart';

import '../../../domain/entities/review_entity.dart';

sealed class MyReviewState extends Equatable {
  const MyReviewState();

  @override
  List<Object?> get props => [];
}

final class MyReviewStateInitial extends MyReviewState {}

final class MyReviewStateLoading extends MyReviewState {}

final class MyReviewStateLoaded extends MyReviewState {
  final List<ReviewEntity> reviews;

  const MyReviewStateLoaded({
    required this.reviews,
  });

  @override
  List<Object?> get props => [reviews];

  MyReviewStateLoaded copy({
    List<ReviewEntity>? reviews,
  }) {
    return MyReviewStateLoaded(reviews: reviews ?? this.reviews);
  }
}
