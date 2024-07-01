import 'package:equatable/equatable.dart';

class ClinicLocationEntity extends Equatable {
  final String? id;
  final String? name;

  const ClinicLocationEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
