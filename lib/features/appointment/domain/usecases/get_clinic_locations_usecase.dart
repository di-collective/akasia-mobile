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
    );
  }
}

class GetClinicLocationsUseCaseParams {
  final String? clinicId;

  GetClinicLocationsUseCaseParams({
    required this.clinicId,
  });
}
