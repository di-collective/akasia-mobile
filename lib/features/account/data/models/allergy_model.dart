import '../../domain/entities/allergy_entity.dart';

class AllergyModel extends AllergyEntity {
  const AllergyModel({
    super.id,
    super.allergy,
    super.description,
  });

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: json['id'],
      allergy: json['allergy'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergy': allergy,
      'description': description,
    };
  }
}
