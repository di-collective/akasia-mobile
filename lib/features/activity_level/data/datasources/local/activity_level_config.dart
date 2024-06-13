import '../../models/activity_level_model.dart';

class ActivityLevelLocalConfig {
  static List<ActivityLevelModel> get allActivityLevels {
    return [
      const ActivityLevelModel(
        id: '1',
        activity: 'Sedentary',
        description: 'I sit at my desk all day',
      ),
      const ActivityLevelModel(
        id: '2',
        activity: 'Lightly Active',
        description: 'I occasionaly exercise or walk for 30 minutes',
      ),
      const ActivityLevelModel(
        id: '3',
        activity: 'Moderately Active',
        description: 'I spend an hour or more working out everyday',
      ),
      const ActivityLevelModel(
        id: '4',
        activity: 'Very Active',
        description: 'I love working out, and want to get more exercise',
      ),
    ];
  }
}
