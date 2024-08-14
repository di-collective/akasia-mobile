import '../../../../core/usecases/usecase.dart';
import '../entities/clinic_entity.dart';
import '../repositories/clinic_repository.dart';

class GetClinicsUseCase
    extends UseCase<List<ClinicEntity>, GetClinicsUseCaseParams> {
  final ClinicRepository clinicRepository;

  GetClinicsUseCase({
    required this.clinicRepository,
  });

  @override
  Future<List<ClinicEntity>> call(GetClinicsUseCaseParams params) async {
    return await clinicRepository.getClinics(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetClinicsUseCaseParams {
  final int? page;
  final int? limit;

  GetClinicsUseCaseParams({
    this.page,
    this.limit,
  });
}
