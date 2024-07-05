import 'package:equatable/equatable.dart';

enum AppointmentDateStatus {
  available,
  booked,
  unavailable,
}

class AppointmentDateEntity extends Equatable {
  final DateTime? date;
  final AppointmentDateStatus? status;
  final int? availableSlots;

  const AppointmentDateEntity({
    this.date,
    this.status,
    this.availableSlots,
  });

  @override
  List<Object?> get props => [
        date,
        status,
        availableSlots,
      ];
}
