part of 'search_foods_cubit.dart';

sealed class SearchFoodsState extends Equatable {
  const SearchFoodsState();

  @override
  List<Object> get props => [];
}

final class SearchFoodsInitial extends SearchFoodsState {}

final class SearchFoodsLoading extends SearchFoodsState {}

final class SearchFoodsLoaded extends SearchFoodsState {
  final List<FoodEntity> foods;

  const SearchFoodsLoaded({
    required this.foods,
  });

  @override
  List<Object> get props => [foods];
}

final class SearchFoodsError extends SearchFoodsState {
  final Object error;

  const SearchFoodsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
