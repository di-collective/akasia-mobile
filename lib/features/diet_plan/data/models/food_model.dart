import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    super.id,
    super.name,
    super.description,
    super.caffeine,
    super.calories,
    super.fatTotal,
    super.protein,
    super.carbohydrates,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      caffeine: json['caffeine'],
      calories: json['calories'],
      fatTotal: json['fat_total'],
      protein: json['protein'],
      carbohydrates: json['carbohydrates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'caffeine': caffeine,
      'calories': calories,
      'fat_total': fatTotal,
      'protein': protein,
      'carbohydrates': carbohydrates,
    };
  }
}

final List<FoodModel> mockFoods = [
  const FoodModel(
    id: '1',
    name: 'Fried Rice',
    description: '219 cals per Serving',
    caffeine: 0,
    calories: 219,
    fatTotal: 5.9,
    protein: 4.2,
    carbohydrates: 35.5,
  ),
  const FoodModel(
    id: '2',
    name: 'Pizza',
    description: '266 cals per Serving',
    caffeine: 0,
    calories: 266,
    fatTotal: 10.2,
    protein: 11.1,
    carbohydrates: 34.3,
  ),
  const FoodModel(
    id: '3',
    name: 'Burger',
    description: '295 cals per Serving',
    caffeine: 0,
    calories: 295,
    fatTotal: 12.6,
    protein: 15.3,
    carbohydrates: 31.1,
  ),
  const FoodModel(
    id: '4',
    name: 'Pasta',
    description: '131 cals per Serving',
    caffeine: 0,
    calories: 131,
    fatTotal: 1.1,
    protein: 5.2,
    carbohydrates: 25.1,
  ),
  const FoodModel(
    id: '5',
    name: 'Noodles',
    description: '138 cals per Serving',
    caffeine: 0,
    calories: 138,
    fatTotal: 2.6,
    protein: 3.4,
    carbohydrates: 25.6,
  ),
  const FoodModel(
    id: '6',
    name: 'Sandwich',
    description: '202 cals per Serving',
    caffeine: 0,
    calories: 202,
    fatTotal: 4.2,
    protein: 6.3,
    carbohydrates: 35.5,
  ),
  const FoodModel(
    id: '7',
    name: 'Salad',
    description: '95 cals per Serving',
    caffeine: 0,
    calories: 95,
    fatTotal: 1.1,
    protein: 3.2,
    carbohydrates: 15.5,
  ),
];
