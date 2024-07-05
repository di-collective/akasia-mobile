import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String? id;
  final String? name;

  const ClinicEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
