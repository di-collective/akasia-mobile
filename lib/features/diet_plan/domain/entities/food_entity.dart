import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;

  const FoodEntity({
    this.id,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
      ];
}
