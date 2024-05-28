import '../../../../../core/config/country_config.dart';
import '../../../../../core/utils/logger.dart';
import '../../models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCountries({
    String? phoneCode,
    String? name,
  });
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  @override
  Future<List<CountryModel>> getCountries({
    String? phoneCode,
    String? name,
  }) async {
    try {
      Logger.info('getCountries phoneCode: $phoneCode, name: $name');

      final countries = CountryConfig.allCountries.map((country) {
        return CountryModel.fromJson(country);
      }).toList();

      final filteredCountries = countries.where((country) {
        if (phoneCode != null && phoneCode.isNotEmpty) {
          return country.phoneCode.toLowerCase() == phoneCode.toLowerCase();
        }

        if (name != null && name.isNotEmpty) {
          return country.name.toLowerCase().contains(name.toLowerCase());
        }

        return true;
      }).toList();

      Logger.info('getCountries filteredCountries: $filteredCountries');

      return filteredCountries;
    } catch (error) {
      Logger.error('getCountries error: $error');

      rethrow;
    }
  }
}
