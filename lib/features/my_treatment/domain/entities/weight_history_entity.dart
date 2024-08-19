import 'package:equatable/equatable.dart';

class WeightHistoryEntity extends Equatable {
  final double? weight;
  final DateTime? date;

  const WeightHistoryEntity({
    this.weight,
    this.date,
  });

  @override
  List<Object?> get props => [
        weight,
        date,
      ];
}
