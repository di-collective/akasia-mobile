import '../../domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  final String? address;
  final String? phone;
  final String? createdAt;

  const ClinicModel({
    super.id,
    super.name,
    super.logo,
    this.address,
    this.phone,
    this.createdAt,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      address: json['address'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'phone': phone,
      'created_at': createdAt,
    };
  }
}
