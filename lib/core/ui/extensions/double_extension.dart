extension DoubleExtension on double {
  bool isSame({
    double? otherValue,
  }) {
    return this == otherValue;
  }

  String? get parseToString {
    try {
      // split zero after dot
      final String value = toString();
      final List<String> splitValue = value.split('.');
      if (splitValue.length == 2) {
        if (splitValue[1] == '0') {
          return splitValue[0];
        }
      }

      return value;
    } catch (_) {
      return null;
    }
  }
}
