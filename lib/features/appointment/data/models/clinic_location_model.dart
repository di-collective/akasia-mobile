import 'package:akasia365mc/features/appointment/domain/entities/clinic_location_entity.dart';

class ClinicLocationModel extends ClinicLocationEntity {
  const ClinicLocationModel({
    super.id,
    super.name,
  });

  factory ClinicLocationModel.fromJson(Map<String, dynamic> json) {
    return ClinicLocationModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
