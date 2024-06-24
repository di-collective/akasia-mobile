import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/local/country_local_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryLocalDataSource countryLocalDataSource;

  const CountryRepositoryImpl({
    required this.countryLocalDataSource,
  });

  @override
  Future<List<CountryEntity>> getCountries({
    String? phoneCode,
    String? name,
  }) async {
    try {
      return await countryLocalDataSource.getCountries(
        phoneCode: phoneCode,
        name: name,
      );
    } catch (_) {
      rethrow;
    }
  }
}
