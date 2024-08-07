import '../../../../core/usecases/usecase.dart';
import '../entities/clinic_location_entity.dart';
import '../repositories/clinic_repository.dart';

class GetClinicLocationsUseCase extends UseCase<List<ClinicLocationEntity>,
    GetClinicLocationsUseCaseParams> {
  final ClinicRepository clinicRepository;

  GetClinicLocationsUseCase({
    required this.clinicRepository,
  });

  @override
  Future<List<ClinicLocationEntity>> call(
      GetClinicLocationsUseCaseParams params) async {
    return await clinicRepository.getClinicLocations(
      clinicId: params.clinicId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetClinicLocationsUseCaseParams {
  final String? clinicId;
  final int? page;
  final int? limit;

  GetClinicLocationsUseCaseParams({
    required this.clinicId,
    this.page,
    this.limit,
  });
}
