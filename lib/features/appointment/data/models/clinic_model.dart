import '../../domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    super.id,
    super.name,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
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
