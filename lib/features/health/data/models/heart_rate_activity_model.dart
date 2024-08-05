import '../../domain/entities/heart_rate_activity_entity.dart';

class HeartRateActivityModel extends HeartRateActivityEntity {
  final String? unit;
  final bool? isManualEntry;
  final String? dataType;

  const HeartRateActivityModel({
    required super.fromDate,
    required super.toDate,
    required super.value,
    this.unit,
    this.isManualEntry,
    this.dataType,
  });

  factory HeartRateActivityModel.fromJson(Map<String, dynamic> json) {
    return HeartRateActivityModel(
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      value: json['value'],
      unit: json['unit'],
      isManualEntry: json['is_manual_entry'],
      dataType: json['data_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_date': fromDate,
      'to_date': toDate,
      'value': value,
      'unit': unit,
      'is_manual_entry': isManualEntry,
      'data_type': dataType,
    };
  }
}
