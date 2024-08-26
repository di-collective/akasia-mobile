extension DoubleExtension on double {
  bool isSame({
    double? otherValue,
  }) {
    return this == otherValue;
  }

  String parseToString({
    bool? isRemoveMinus,
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
    }

    return result;
  }
}
