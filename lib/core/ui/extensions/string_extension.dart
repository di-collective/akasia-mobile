extension StringExtension on String {
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isContainsLetter {
    return RegExp(r'[a-zA-Z]').hasMatch(this);
  }

  bool get isContainsNumber {
    return RegExp(r'[0-9]').hasMatch(this);
  }

  bool get isContainsUpperCase {
    return RegExp(r'[A-Z]').hasMatch(this);
  }

  bool get isContainsLowerCase {
    return RegExp(r'[a-z]').hasMatch(this);
  }

  bool get isContainsSpecialCharacter {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);
  }

  String toCapitalize() {
    if (length < 2) return toUpperCase();

    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toCapitalizes() {
    if (length < 2) return toUpperCase();
    if (split(' ').length < 2) return toCapitalize();

    final List<String> values = split(' ');
    String result = "";

    for (String val in values) {
      if (val.length > 1) {
        result += "${val[0].toUpperCase()}${val.substring(1).toLowerCase()} ";
      } else {
        result += "$val ";
      }
    }

    return result;
  }

  Uri? get toUri {
    try {
      if (isTelpUrl) {
        return Uri(
          scheme: 'tel',
          path: split(':')[1], // remove tel:
        );
      }

      return Uri.tryParse(this);
    } catch (_) {
      rethrow;
    }
  }

  String get toTelpUrl {
    return 'tel:$this';
  }

  bool get isTelpUrl {
    return RegExp(r'^tel:[0-9]+$').hasMatch(this);
  }

  bool get isKtp {
    return RegExp(
            r'^(1[1-9]|21|[37][1-6]|5[1-3]|6[1-5]|[89][12])\d{2}\d{2}([04][1-9]|[1256][0-9]|[37][01])(0[1-9]|1[0-2])\d{2}\d{4}$')
        .hasMatch(this);
  }
}
