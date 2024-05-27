import '../../domain/entities/activity_level_entity.dart';

class ActivityLevelModel extends ActivityLevelEntity {
  const ActivityLevelModel({
    super.id,
    super.activity,
    super.description,
  });

  factory ActivityLevelModel.fromJson(Map<String, dynamic> json) {
    return ActivityLevelModel(
      id: json['id'],
      activity: json['activity'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'description': description,
    };
  }
}
