extension DoubleExtension on double {
  bool isSame({
    double? otherValue,
  }) {
    return this == otherValue;
  }

  String parseToString({
    bool? isRemoveMinus,
    int? maxFractionDigits,
  }) {
    String result = toString();

    // remove minus
    if (isRemoveMinus == true) {
      if (result.startsWith('-')) {
        result = result.substring(1);
      }
    }

    // split zero after dot
    if (result.contains('.')) {
      final split = result.split('.');
      if (split.length == 2) {
        final decimal = split[1];
        if (decimal == '0') {
          result = split.first;
        }
      }

      // max fraction digits
      if (maxFractionDigits != null) {
        final split = result.split('.');
        if (split.length == 2) {
          final decimal = split[1];
          if (decimal.length > maxFractionDigits) {
            result = '${split[0]}.${decimal.substring(0, maxFractionDigits)}';
          }
        }
      }
    }

    return result;
  }
}
