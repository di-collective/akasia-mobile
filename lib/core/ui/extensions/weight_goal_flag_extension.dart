import '../../config/asset_path.dart';

enum WeightGoalFlag {
  loss,
  gain,
  maintain,
}

extension WeightGoalFlagExtension on WeightGoalFlag {
  String get title {
    switch (this) {
      case WeightGoalFlag.loss:
        return "Loss";
      case WeightGoalFlag.gain:
        return "Gain";
      case WeightGoalFlag.maintain:
        return "Maintain";
    }
  }

  String get iconPath {
    switch (this) {
      case WeightGoalFlag.loss:
        return AssetIconsPath.icArrowCircleDown;
      case WeightGoalFlag.gain:
      case WeightGoalFlag.maintain:
        return AssetIconsPath.icArrowCircleUp;
    }
  }

  static WeightGoalFlag? fromString(String? value) {
    if (value == null) {
      return null;
    }

    final flag = value.toLowerCase();
    switch (flag) {
      case "loss":
        return WeightGoalFlag.loss;
      case "gain":
        return WeightGoalFlag.gain;
      case "maintain":
        return WeightGoalFlag.maintain;
    }

    return null;
  }
}
