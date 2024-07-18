import 'package:intl/intl.dart';

extension IntExtension on int {
  String formatNumber({
    String? locale,
  }) {
    final formatter = NumberFormat.decimalPattern(
      locale,
    );

    return formatter.format(this);
  }
}
