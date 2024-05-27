part of 'countries_cubit.dart';

sealed class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

final class CountriesInitial extends CountriesState {}

final class CountriesLoading extends CountriesState {}

final class CountriesLoaded extends CountriesState {
  final List<CountryModel> countries;

  const CountriesLoaded({
    required this.countries,
  });

  @override
  List<Object> get props => [countries];
}

final class CountriesError extends CountriesState {
  final Object error;

  const CountriesError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
