import '../../../../core/ui/extensions/dynamic_extension.dart';
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
    super.age,
    super.dob,
    super.sex,
    super.bloodType,
    super.weight,
    super.height,
    super.activityLevel,
    super.allergies,
    super.ecName,
    super.ecRelation,
    super.ecCountryCode,
    super.ecPhone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'],
      role: json['role'],
      medicalId: json['medical_id'],
      name: json['name'],
      countryCode: json['country_code'],
      phone: json['phone'],
      // nik: json['nik'], // TODO: Uncomment this, because default nik is not valid format
      age: json['age'],
      dob: json['dob'],
      sex: json['sex'],
      bloodType: json['blood_type'],
      weight: DynamicExtension(json['weight']).dynamicToDouble,
      height: DynamicExtension(json['height']).dynamicToDouble,
      activityLevel: json['activity_level'],
      allergies: json['allergies'],
      ecName: json['ec_name'],
      ecRelation: json['ec_relation'],
      ecCountryCode: json['ec_country_code'],
      ecPhone: json['ec_phone'],
    );
  }
}
