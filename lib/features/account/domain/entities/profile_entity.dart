import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String? photoUrl;
  final String? role;
  final String? medicalId;
  final String? name;
  final String? countryCode;
  final String? phone;
  final String? nik;
  final String? age;
  final String? dob;
  final String? sex;
  final String? bloodType;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? allergies;
  final String? ecName;
  final String? ecRelation;
  final String? ecCountryCode;
  final String? ecPhone;

  const ProfileEntity({
    this.userId,
    this.photoUrl,
    this.role,
    this.medicalId,
    this.name,
    this.countryCode,
    this.phone,
    this.nik,
    this.age,
    this.dob,
    this.sex,
    this.bloodType,
    this.weight,
    this.height,
    this.activityLevel,
    this.allergies,
    this.ecName,
    this.ecRelation,
    this.ecCountryCode,
    this.ecPhone,
  });

  ProfileEntity copyWith({
    bool? isForceAllergies,
    String? userId,
    String? photoUrl,
    String? role,
    String? medicalId,
    String? name,
    String? countryCode,
    String? phone,
    String? nik,
    String? age,
    String? dob,
    String? sex,
    String? bloodType,
    double? weight,
    double? height,
    String? activityLevel,
    String? allergies,
    String? ecName,
    String? ecRelation,
    String? ecCountryCode,
    String? ecPhone,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      medicalId: medicalId ?? this.medicalId,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      nik: nik ?? this.nik,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      sex: sex ?? this.sex,
      bloodType: bloodType ?? this.bloodType,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      allergies:
          (isForceAllergies == true) ? allergies : allergies ?? this.allergies,
      ecName: ecName ?? this.ecName,
      ecRelation: ecRelation ?? this.ecRelation,
      ecCountryCode: ecCountryCode ?? this.ecCountryCode,
      ecPhone: ecPhone ?? this.ecPhone,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        photoUrl,
        role,
        medicalId,
        name,
        countryCode,
        phone,
        nik,
        age,
        dob,
        sex,
        bloodType,
        weight,
        height,
        activityLevel,
        allergies,
        ecName,
        ecRelation,
        ecCountryCode,
        ecPhone,
      ];
}
