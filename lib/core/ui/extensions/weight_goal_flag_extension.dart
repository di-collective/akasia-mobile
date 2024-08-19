import 'package:akasia365mc/core/config/asset_path.dart';

enum WeightGoalFlag {
  maintain,
  loss,
  gain,
}

extension WeightGoalFlagExtension on WeightGoalFlag {
  String get title {
    switch (this) {
      case WeightGoalFlag.maintain:
        return "Maintain";
      case WeightGoalFlag.loss:
        return "Loss";
      case WeightGoalFlag.gain:
        return "Gain";
    }
  }

  String get iconPath {
    switch (this) {
      case WeightGoalFlag.maintain:
        return AssetIconsPath.icArrowCircleDown;
      case WeightGoalFlag.loss:
        return AssetIconsPath.icArrowCircleDown;
      case WeightGoalFlag.gain:
        return AssetIconsPath.icArrowCircleUp;
    }
  }

  static WeightGoalFlag? fromString(String? value) {
    if (value == null) {
      return null;
    }

    final flag = value.toLowerCase();
    switch (flag) {
      case "maintain":
        return WeightGoalFlag.maintain;
      case "loss":
        return WeightGoalFlag.loss;
      case "gain":
        return WeightGoalFlag.gain;
    }

    return null;
  }
}
