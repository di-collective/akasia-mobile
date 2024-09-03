import 'package:flutter/material.dart';
import 'package:health/health.dart';

import '../../utils/logger.dart';
import 'string_extension.dart';

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
      } else if (this is NutritionHealthValue) {
        result = (this as NutritionHealthValue).calories;
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
        result = (this as String).toDateTime();
      }

      Logger.success('dynamicToDateTime result $result');

      return result;
    } catch (e) {
      Logger.error('dynamicToDateTime error $e');

      return null;
    }
  }

  int? get dynamicToInt {
    try {
      Logger.info('dynamicToInt $this type $runtimeType');

      int? result;

      if (this is String) {
        result = int.parse(this);
      } else if (this is int) {
        result = this;
      } else if (this is double) {
        result = (this as double).toInt();
      } else if (this is NumericHealthValue) {
        result = (this as NumericHealthValue).numericValue.toInt();
      }

      Logger.success('dynamicToInt result $result');

      return result;
    } catch (e) {
      Logger.error('dynamicToInt error $e');

      return 0;
    }
  }

  TimeOfDay? get dynamicToTimeOfDay {
    try {
      Logger.info('dynamicToTimeOfDay $this type $runtimeType');

      TimeOfDay? result;

      final time = this;
      if (this is String) {
        final parts = (this as String).split(':');
        if (parts.isNotEmpty) {
          final hour = int.parse(parts[0]);
          int? minute;

          if (parts.length > 1) {
            minute = int.parse(parts[1]);
          }

          result = TimeOfDay(
            hour: hour,
            minute: minute ?? 0,
          );
        }
      } else if (this is TimeOfDay) {
        result = time;
      }

      Logger.success('dynamicToTimeOfDay result $result');

      return result;
    } catch (e) {
      Logger.error('dynamicToTimeOfDay error $e');

      return null;
    }
  }
}
