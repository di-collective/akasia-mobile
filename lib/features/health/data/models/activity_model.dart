import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    super.createdAt,
    super.updatedAt,
    super.data,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DynamicExtension(json['updated_at']).dynamicToDateTime
          : null,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'updated_at': updatedAt,
      'data': data,
    };
  }
}
