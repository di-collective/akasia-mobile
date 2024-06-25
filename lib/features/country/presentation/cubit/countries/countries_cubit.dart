import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/get_countries_usecase.dart';

part 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final GetCountriesUseCase getCountriesUseCase;

  CountriesCubit({
    required this.getCountriesUseCase,
  }) : super(CountriesInitial());

  Future<List<CountryEntity>> getCountries({
    String? phoneCode,
    String? name,
  }) async {
    try {
      emit(CountriesLoading());

      final countries = await getCountriesUseCase(GetCountriesUseCaseParams(
        phoneCode: phoneCode,
        name: name,
      ));

      emit(CountriesLoaded(
        countries: countries,
      ));

      return countries;
    } catch (error) {
      emit(CountriesError(
        error: error,
      ));

      rethrow;
    }
  }
}
