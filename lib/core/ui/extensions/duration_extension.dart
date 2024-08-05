extension DurationExtension on Duration {
  /// Returns the duration in minutes.
  ///
  /// Example:
  /// ```dart
  /// final Duration duration = Duration(hours: 2, minutes: 30);
  /// print(duration.remainingMinutes); // 30
  /// ```
  ///
  /// This will return `30`.
  ///
  /// This is useful when you want to get the remaining minutes after calculating the hours.
  String get remainingMinutes {
    return (inMinutes % 60).toString();
  }

  /// Returns the duration in seconds.
  ///
  /// Example:
  /// ```dart
  /// final Duration duration = Duration(hours: 2, minutes: 30, seconds: 45);
  /// print(duration.remainingSeconds); // 45
  /// ```
  ///
  /// This will return `45`.
  ///
  /// This is useful when you want to get the remaining seconds after calculating the hours and minutes.
  String get remainingSeconds {
    return (inSeconds % 60).toString();
  }
}
