import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userName;
  final double? userEffectivenessRating;
  final double? userValueForMoneyRating;
  final String? userReview;
  final String treatmentName;
  final String treatmentDescription;
  final double treatmentAverageRating;
  final int treatmentTotalReviews;
  final String updatedAt;

  const ReviewEntity({
    required this.id,
    required this.userName,
    this.userEffectivenessRating,
    this.userValueForMoneyRating,
    this.userReview,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.treatmentAverageRating,
    required this.treatmentTotalReviews,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userName,
        userEffectivenessRating,
        userValueForMoneyRating,
        userReview,
        treatmentName,
        treatmentDescription,
        treatmentAverageRating,
        treatmentTotalReviews,
        updatedAt,
      ];
}
