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
}
