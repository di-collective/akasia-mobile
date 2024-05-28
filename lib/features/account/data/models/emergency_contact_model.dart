import '../../domain/entities/emergency_contact_entity.dart';

class EmergencyContactModel extends EmergencyContacyEntity {
  const EmergencyContactModel({
    super.relationship,
    super.name,
    super.countryCode,
    super.phoneNumber,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      relationship: json['relationship'],
      name: json['name'],
      countryCode: json['country_code'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationship': relationship,
      'name': name,
      'country_code': countryCode,
      'phone_number': phoneNumber,
    };
  }
}
