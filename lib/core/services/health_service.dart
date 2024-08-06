import 'dart:io';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/routes/app_route_info.dart';
import '../../features/diet_plan/domain/entities/food_entity.dart';
import '../ui/extensions/build_context_extension.dart';
import '../ui/extensions/date_time_extension.dart';
import '../utils/logger.dart';
import '../utils/permission_info.dart';
import '../utils/service_locator.dart';

abstract class HealthService {
  /// Check if the user has the required permissions
  ///
  /// Returns `true` if the user has the required permissions, `false` if the user does not have the required permissions, and `null` if the user has not yet granted or denied the permissions
  ///
  /// Note:
  /// - This method should be called before calling [connect]
  /// - Only works on Android, returns `null` on iOS
  Future<bool?> get hasPermissions;

  Future<bool?> connect();

  Future<bool?> disconnect();

  Duration get refreshIntervalDuration;

  Future<int?> getTotalStepsInInterval({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<List<HealthDataPoint>> getSleepSessions({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<List<HealthDataPoint>> getHearRate({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<List<HealthDataPoint>> getWorkout({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<List<HealthDataPoint>> getNutrition({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<void> addMeal({
    required MealType mealType,
    required DateTime startTime,
    required DateTime endTime,
    required FoodEntity meal,
    required int quantity,
  });
}

class HealthServiceImpl implements HealthService {
  final Health health;
  final PermissionInfo permissionInfo;

  HealthServiceImpl({
    required this.health,
    required this.permissionInfo,
  });

  final _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.NUTRITION,
    HealthDataType.WORKOUT,
    _sleepHealthDataType,
  ];

  // the length of this list must be the same as the length of _types
  final _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  final _nativePermissions = [
    Permission.activityRecognition,
    Permission.location,
  ];

  static HealthDataType get _sleepHealthDataType {
    if (Platform.isAndroid) {
      return HealthDataType.SLEEP_SESSION;
    } else {
      return HealthDataType.SLEEP_ASLEEP;
    }
  }

  Future<void> configure() async {
    try {
      await health.configure(
        useHealthConnectIfAvailable: true,
      );
    } catch (error) {
      Logger.error('configure error: $error');

      rethrow;
    }
  }

  @override
  Future<bool?> get hasPermissions async {
    try {
      Logger.info('hasPermissions');

      bool? hasPermissions;
      if (Platform.isAndroid) {
        // configure health
        await configure();

        // check permissions
        hasPermissions = await health.hasPermissions(
          _types,
          permissions: _permissions,
        );
      }
      Logger.success('hasPermissions: $hasPermissions');

      return hasPermissions;
    } catch (error) {
      Logger.error('hasPermissions error: $error');

      rethrow;
    }
  }

  @override
  Future<bool?> connect() async {
    try {
      Logger.info('connect');

      bool? isAuthorized;
      if (Platform.isAndroid) {
        // check health connect sdk status
        final healthConnectSdkStatus = await health.getHealthConnectSdkStatus();
        Logger.success(
            'connect healthConnectSdkStatus: $healthConnectSdkStatus');
        if (healthConnectSdkStatus != null) {
          switch (healthConnectSdkStatus) {
            case HealthConnectSdkStatus.sdkAvailable:
              // continue
              break;
            case HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired:
              throw 'Health Connect SDK is unavailable, provider update required';
            case HealthConnectSdkStatus.sdkUnavailable:
              throw 'Health Connect SDK is unavailable, please install the health connect App before connecting';
          }
        }

        // request native permission
        for (final permission in _nativePermissions) {
          final isGranted = await permissionInfo.requestPermission(
            permission: permission,
          );
          if (!isGranted) {
            return false;
          }
        }

        // check has permissions
        isAuthorized = await hasPermissions;
      }

      if (isAuthorized != true) {
        // request health permission
        isAuthorized = await health.requestAuthorization(
          _types,
          permissions: _permissions,
        );
      }
      Logger.success('connect isAuthorized: $isAuthorized');

      return isAuthorized;
    } catch (error) {
      Logger.error('connect error: $error');

      rethrow;
    }
  }

  @override
  Future<bool?> disconnect() async {
    try {
      Logger.info('disconnect');

      if (Platform.isIOS) {
        // the health plugin does not support disconnecting on iOS
        // show warning toast
        final context = sl<AppRouteInfo>().navigatorKey.currentContext;
        context?.showWarningToast(
          message:
              'This feature is not supported on iOS, please revoke the permissions manually',
        );

        return null;
      }

      // revoke permissions
      await health.revokePermissions();

      Logger.success('disconnect');

      return true;
    } catch (error) {
      Logger.error('disconnect error: $error');

      rethrow;
    }
  }

  @override
  Duration get refreshIntervalDuration {
    return const Duration(
      minutes: 3, // TODO: Change this to 30 minutes
    );
  }

  @override
  Future<int?> getTotalStepsInInterval({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      Logger.info(
          'getTotalStepsInInterval startTime: $startTime, endTime: $endTime');

      final result = await health.getTotalStepsInInterval(
        startTime,
        endTime,
      );
      Logger.success('getTotalStepsInInterval result: $result');

      return result;
    } catch (error) {
      Logger.error('getTotalStepsInInterval error: $error');

      rethrow;
    }
  }

  @override
  Future<List<HealthDataPoint>> getSleepSessions({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      Logger.info('getSleepSessions startTime: $startTime, endTime: $endTime');

      // FIXME: return empty list on iOS
      final result = await health.getHealthDataFromTypes(
        types: [
          _sleepHealthDataType,
        ],
        startTime: startTime,
        endTime: endTime,
      );
      Logger.success('getSleepSessions result: $result');

      await getWorkout(
        startTime: startTime.firstHourOfDay,
        endTime: endTime,
      );

      return result;
    } catch (error) {
      Logger.error('getSleepSessions error: $error');

      rethrow;
    }
  }

  @override
  Future<List<HealthDataPoint>> getHearRate({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      Logger.info('getHearRate startTime: $startTime, endTime: $endTime');

      final result = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.HEART_RATE,
        ],
        startTime: startTime,
        endTime: endTime,
      );
      Logger.success('getHearRate result: $result');

      return result;
    } catch (error) {
      Logger.error('getHearRate error: $error');

      rethrow;
    }
  }

  @override
  Future<List<HealthDataPoint>> getWorkout({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      Logger.info('getWorkout startTime: $startTime, endTime: $endTime');

      final result = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.WORKOUT,
        ],
        startTime: startTime,
        endTime: endTime,
      );
      Logger.success('getWorkout result: $result');

      return result;
    } catch (error) {
      Logger.error('getWorkout error: $error');

      rethrow;
    }
  }

  @override
  Future<List<HealthDataPoint>> getNutrition({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      Logger.info('getNutrition startTime: $startTime, endTime: $endTime');

      final result = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.NUTRITION,
        ],
        startTime: startTime,
        endTime: endTime,
      );
      Logger.success('getNutrition result: $result');

      return result;
    } catch (error) {
      Logger.error('getNutrition error: $error');

      rethrow;
    }
  }

  @override
  Future<void> addMeal({
    required MealType mealType,
    required DateTime startTime,
    required DateTime endTime,
    required FoodEntity meal,
    required int quantity,
  }) async {
    try {
      Logger.info(
          'addMeal startTime: $startTime, endTime: $endTime, meal: $meal, quantity: $quantity');

      double? caffeine = meal.caffeine;
      double? calories = meal.calories;
      double? fatTotal = meal.fatTotal;
      double? protein = meal.protein;
      double? carbohydrates = meal.carbohydrates;
      if (quantity > 1) {
        // multiply the values by quantity
        caffeine = caffeine! * quantity;
        calories = calories! * quantity;
        fatTotal = fatTotal! * quantity;
        protein = protein! * quantity;
        carbohydrates = carbohydrates! * quantity;
      }

      // write meal
      final result = await health.writeMeal(
        mealType: mealType,
        startTime: startTime,
        endTime: endTime,
        name: meal.name,
        caffeine: caffeine,
        caloriesConsumed: calories,
        fatTotal: fatTotal,
        protein: protein,
        carbohydrates: carbohydrates,
      );
      Logger.success('addMeal result: $result');
    } catch (error) {
      Logger.error('addMeal error: $error');

      rethrow;
    }
  }
}
