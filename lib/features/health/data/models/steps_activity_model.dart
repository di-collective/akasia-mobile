import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/steps_activity_entity.dart';

class StepsActivityModel extends StepsActivityEntity {
  const StepsActivityModel({
    super.count,
    super.date,
  });

  factory StepsActivityModel.fromJson(Map<String, dynamic> json) {
    return StepsActivityModel(
      count: json['count'],
      date: DynamicExtension(json['date']).dynamicToDateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'date': date,
    };
  }
}
