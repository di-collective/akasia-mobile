import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.userId,
    super.role,
    super.medicalId,
    super.name,
    super.countryCode,
    super.phone,
    super.nik,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'],
      role: json['role'],
      medicalId: json['medical_id'],
      name: json['name'],
      countryCode: json['country_code'],
      phone: json['phone'],
      nik: json['nik'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role': role,
      'medical_id': medicalId,
      'name': name,
      'country_code': countryCode,
      'phone': phone,
      'nik': nik,
    };
  }
}
