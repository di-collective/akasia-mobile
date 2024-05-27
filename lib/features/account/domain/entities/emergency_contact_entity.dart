import 'package:equatable/equatable.dart';

class EmergencyContacyEntity extends Equatable {
  final String? relationship;
  final String? name;
  final String? countryCode;
  final String? phoneNumber;

  const EmergencyContacyEntity({
    this.relationship,
    this.name,
    this.countryCode,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        relationship,
        name,
        countryCode,
        phoneNumber,
      ];
}
