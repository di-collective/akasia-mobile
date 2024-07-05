import 'package:equatable/equatable.dart';

import 'appointment_date_entity.dart';

enum LoadStatus {
  initial,
  loading,
  loaded,
  error,
}

class AppointmentMonthEntity extends Equatable {
  final DateTime? month;
  final LoadStatus? status;
  final List<AppointmentDateEntity>? dates;

  const AppointmentMonthEntity({
    this.month,
    this.status,
    this.dates,
  });

  AppointmentMonthEntity copyWith({
    DateTime? month,
    LoadStatus? status,
    List<AppointmentDateEntity>? dates,
  }) {
    return AppointmentMonthEntity(
      month: month ?? this.month,
      status: status ?? this.status,
      dates: dates ?? this.dates,
    );
  }

  @override
  List<Object?> get props => [
        month,
        status,
        dates,
      ];
}
