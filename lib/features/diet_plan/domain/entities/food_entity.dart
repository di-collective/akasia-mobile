import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final double? caffeine;
  final double? calories;
  final double? fatTotal;
  final double? protein;
  final double? carbohydrates;

  const FoodEntity({
    this.id,
    this.name,
    this.description,
    this.caffeine,
    this.calories,
    this.fatTotal,
    this.protein,
    this.carbohydrates,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        caffeine,
        calories,
        fatTotal,
        protein,
        carbohydrates,
      ];
}
