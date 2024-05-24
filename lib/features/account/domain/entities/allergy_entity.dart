import 'package:equatable/equatable.dart';

class AllergyEntity extends Equatable {
  final String? id;
  final String? allergy;

  const AllergyEntity({
    this.id,
    this.allergy,
  });

  @override
  List<Object?> get props => [id, allergy];
}
