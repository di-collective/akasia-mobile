import 'dart:async';
import 'dart:ui';

class DebouncerInfo {
  final int milliseconds;

  DebouncerInfo({
    required this.milliseconds,
  });

  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}
