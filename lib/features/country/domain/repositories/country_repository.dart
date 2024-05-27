import '../../data/models/country_model.dart';

abstract class CountryRepository {
  Future<List<CountryModel>> getCountries({
    String? phoneCode,
    String? name,
  });
}
