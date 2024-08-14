import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String? id;
  final String? name;
  final String? logo;

  const ClinicEntity({
    this.id,
    this.name,
    this.logo,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
      ];
}
