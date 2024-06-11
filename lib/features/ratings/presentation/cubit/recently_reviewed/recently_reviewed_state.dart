import 'package:equatable/equatable.dart';

import '../../../domain/entities/review_entity.dart';

sealed class RecentlyReviewedState extends Equatable {
  const RecentlyReviewedState();

  @override
  List<Object?> get props => [];
}

final class RecentlyReviewedStateInitial extends RecentlyReviewedState {}

final class RecentlyReviewedStateLoading extends RecentlyReviewedState {}

final class RecentlyReviewedStateLoaded extends RecentlyReviewedState {
  final List<ReviewEntity> reviews;

  const RecentlyReviewedStateLoaded({
    required this.reviews,
  });
}
