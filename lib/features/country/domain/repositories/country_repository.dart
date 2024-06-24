import '../entities/country_entity.dart';

abstract class CountryRepository {
  Future<List<CountryEntity>> getCountries({
    String? phoneCode,
    String? name,
  });
}
