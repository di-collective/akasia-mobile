import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
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
  final String? ecRelation;

  const ProfileEntity({
    this.userId,
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
    this.ecRelation,
  });

  ProfileEntity copyWith({
    String? userId,
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
    String? ecRelation,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
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
      allergies: allergies ?? this.allergies,
      ecRelation: ecRelation ?? this.ecRelation,
    );
  }

  @override
  List<Object?> get props => [
        userId,
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
        ecRelation,
      ];
}
