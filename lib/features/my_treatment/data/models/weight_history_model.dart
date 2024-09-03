import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/weight_history_entity.dart';

class WeightHistoryModel extends WeightHistoryEntity {
  const WeightHistoryModel({
    required super.weight,
    required super.date,
  });

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) {
    return WeightHistoryModel(
      weight: DynamicExtension(
        json['weight'],
      ).dynamicToDouble,
      date: DynamicExtension(
        json['date'],
      ).dynamicToDateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'date': date,
    };
  }
}
