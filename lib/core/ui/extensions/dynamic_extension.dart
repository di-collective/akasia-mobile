import '../../utils/logger.dart';

extension DynamicExtension on dynamic {
  /// Convert dynamic to double
  ///
  /// Example: "100"
  ///
  /// Return: 100.0
  double? get dynamicToDouble {
    try {
      Logger.info('dynamicToDouble $this type $runtimeType');

      double? result;

      if (this is String) {
        result = double.parse(this);
      } else if (this is int) {
        result = (this as int).toDouble();
      } else if (this is double) {
        result = this;
      }

      Logger.success('dynamicToDouble result $result');

      return result;
    } catch (e) {
      Logger.error('dynamicToDouble error $e');

      return 0.0;
    }
  }

  DateTime? get dynamicToDateTime {
    try {
      Logger.info('dynamicToDateTime $this type $runtimeType');

      DateTime? result;

      if (this is String) {
        result = DateTime.tryParse(this);
      }

      Logger.success('dynamicToDateTime result $result');

      return result;
    } catch (e) {
      Logger.error('dynamicToDateTime error $e');

      return null;
    }
  }
}
