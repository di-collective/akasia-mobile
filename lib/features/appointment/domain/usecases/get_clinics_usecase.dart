import '../../../../core/usecases/usecase.dart';
import '../entities/clinic_entity.dart';
import '../repositories/clinic_repository.dart';

class GetClinicsUseCase extends UseCase<List<ClinicEntity>, NoParams> {
  final ClinicRepository clinicRepository;

  GetClinicsUseCase({
    required this.clinicRepository,
  });

  @override
  Future<List<ClinicEntity>> call(NoParams params) async {
    return await clinicRepository.getClinics();
  }
}
