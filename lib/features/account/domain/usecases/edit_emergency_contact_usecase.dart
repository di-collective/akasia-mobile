import '../../../../core/usecases/usecase.dart';
import '../../data/models/emergency_contact_model.dart';
import '../repositories/emergency_contact_repository.dart';

class EditEmergencyContactUseCase
    extends UseCase<void, EditEmergencyContactUseCaseParams> {
  final EmergencyContactRepository emergencyContactRepository;

  EditEmergencyContactUseCase({
    required this.emergencyContactRepository,
  });

  @override
  Future<void> call(EditEmergencyContactUseCaseParams params) {
    return emergencyContactRepository.editEmergencyContact(
      emergencyContact: params.emergencyContact,
    );
  }
}

class EditEmergencyContactUseCaseParams {
  final EmergencyContactModel emergencyContact;

  EditEmergencyContactUseCaseParams({
    required this.emergencyContact,
  });
}
