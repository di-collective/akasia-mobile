extension DurationExtension on Duration {
  /// Returns the duration in hours.
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
}
