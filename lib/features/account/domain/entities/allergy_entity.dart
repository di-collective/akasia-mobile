import 'package:equatable/equatable.dart';

class AllergyEntity extends Equatable {
  final String? id;
  final String? allergy;
  final String? description;

  const AllergyEntity({
    this.id,
    this.allergy,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        allergy,
        description,
      ];
}
