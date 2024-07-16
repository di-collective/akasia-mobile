import 'package:equatable/equatable.dart';

class EatCalendarEntity extends Equatable {
  final DateTime? date;
  final double? currentValue;
  final double? limitMaxValue;

  const EatCalendarEntity({
    this.date,
    this.currentValue,
    this.limitMaxValue,
  });

  @override
  List<Object?> get props => [
        date,
        currentValue,
        limitMaxValue,
      ];
}
