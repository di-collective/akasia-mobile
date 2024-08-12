import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/clinic_location_entity.dart';

class ClinicLocationModel extends ClinicLocationEntity {
  final String? createdAt;

  const ClinicLocationModel({
    super.id,
    super.name,
    super.address,
    super.phone,
    super.openingTime,
    super.closingTime,
    this.createdAt,
  });

  factory ClinicLocationModel.fromJson(Map<String, dynamic> json) {
    return ClinicLocationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      openingTime: DynamicExtension(
        json['opening_time'],
      ).dynamicToTimeOfDay,
      closingTime: DynamicExtension(
        json['closing_time'],
      ).dynamicToTimeOfDay,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'created_at': createdAt,
    };
  }
}
