import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    super.id,
    super.name,
    super.description,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

final List<FoodModel> mockFoods = [
  const FoodModel(
    id: '1',
    name: 'Nasi Goreng',
    description: '219 cals per Serving',
  ),
  const FoodModel(
    id: '2',
    name: 'Ayam Goreng',
    description: '319 cals per Serving',
  ),
  const FoodModel(
    id: '3',
    name: 'Mie Goreng',
    description: '419 cals per Serving',
  ),
  const FoodModel(
    id: '4',
    name: 'Sate Ayam',
    description: '519 cals per Serving',
  ),
];
