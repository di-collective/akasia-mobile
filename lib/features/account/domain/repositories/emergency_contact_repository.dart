import '../../data/models/emergency_contact_model.dart';

abstract class EmergencyContactRepository {
  Future<EmergencyContactModel> getEmergencyContact();
  Future<void> editEmergencyContact({
    required EmergencyContactModel emergencyContact,
  });
}
