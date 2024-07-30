import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';

import '../../../data/models/food_model.dart';
import '../../../domain/entities/food_entity.dart';

part 'search_foods_state.dart';

class SearchFoodsCubit extends Cubit<SearchFoodsState> {
  SearchFoodsCubit() : super(SearchFoodsInitial());

  void init() {
    emit(SearchFoodsInitial());
  }

  Future<void> searchProducts({
    required MealType mealType,
    required String searchText,
  }) async {
    try {
      emit(SearchFoodsLoading());

      // TODO: Implement searchProducts
      final result = await Future.delayed(
        const Duration(seconds: 2),
        () => mockFoods,
      );

      emit(SearchFoodsLoaded(foods: result));
    } catch (error) {
      emit(SearchFoodsError(error: error));

      rethrow;
    }
  }
}
