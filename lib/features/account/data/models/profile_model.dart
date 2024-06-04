import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String? userId;
  final String? role;
  final String? medicalId;
  final String? name;
  final String? countryCode;
  final String? phone;
  final String? nik;

  const ProfileModel({
    this.userId,
    this.role,
    this.medicalId,
    this.name,
    this.countryCode,
    this.phone,
    this.nik,
  });

  ProfileModel copyWith({
    String? userId,
    String? role,
    String? medicalId,
    String? name,
    String? countryCode,
    String? phone,
    String? nik,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      medicalId: medicalId ?? this.medicalId,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      nik: nik ?? this.nik,
    );
  }

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

  @override
  List<Object?> get props => [
        userId,
        role,
        medicalId,
        name,
        countryCode,
        phone,
        nik,
      ];
}
