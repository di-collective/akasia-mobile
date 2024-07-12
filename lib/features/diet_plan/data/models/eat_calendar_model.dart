import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/eat_calendar_entity.dart';

class EatCalendarModel extends EatCalendarEntity {
  const EatCalendarModel({
    super.date,
    super.currentValue,
    super.limitMaxValue,
  });

  factory EatCalendarModel.fromJson(Map<String, dynamic> json) {
    return EatCalendarModel(
      date: DynamicExtension(json['date']).dynamicToDateTime,
      currentValue: json['current_value'],
      limitMaxValue: json['limit_max_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'current_value': currentValue,
      'limit_max_value': limitMaxValue,
    };
  }
}
