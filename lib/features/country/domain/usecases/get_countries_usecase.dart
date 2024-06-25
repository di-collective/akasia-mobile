import '../../../../core/usecases/usecase.dart';
import '../entities/country_entity.dart';
import '../repositories/country_repository.dart';

class GetCountriesUseCase
    extends UseCase<List<CountryEntity>, GetCountriesUseCaseParams> {
  final CountryRepository countryRepository;

  GetCountriesUseCase({
    required this.countryRepository,
  });

  @override
  Future<List<CountryEntity>> call(GetCountriesUseCaseParams params) async {
    return await countryRepository.getCountries(
      phoneCode: params.phoneCode,
      name: params.name,
    );
  }
}

class GetCountriesUseCaseParams {
  final String? phoneCode;
  final String? name;

  GetCountriesUseCaseParams({
    this.phoneCode,
    this.name,
  });
}
