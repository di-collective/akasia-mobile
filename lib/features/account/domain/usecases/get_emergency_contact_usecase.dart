import '../../../../core/usecases/usecase.dart';
import '../../data/models/emergency_contact_model.dart';
import '../repositories/emergency_contact_repository.dart';

class GetEmergencyContactUseCase
    extends UseCase<EmergencyContactModel, NoParams> {
  final EmergencyContactRepository emergencyContactRepository;

  GetEmergencyContactUseCase({
    required this.emergencyContactRepository,
  });

  @override
  Future<EmergencyContactModel> call(NoParams params) async {
    return await emergencyContactRepository.getEmergencyContact();
  }
}
