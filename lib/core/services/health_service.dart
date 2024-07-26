import 'package:akasia365mc/core/ui/extensions/date_time_extension.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/logger.dart';
import '../utils/permission_info.dart';

abstract class HealthService {
  Future<bool?> requestPermission();

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
    HealthDataType.SLEEP_SESSION,
  ];

  // the length of this list must be the same as the length of _types
  final _permissions = [
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
  ];

  final _nativePermissions = [
    Permission.activityRecognition,
    Permission.location,
  ];

  @override
  Future<bool?> requestPermission() async {
    try {
      Logger.info('requestPermission');

      // configure health connect
      await health.configure(
        useHealthConnectIfAvailable: true,
      );

      // request native permission
      for (final permission in _nativePermissions) {
        final isGranted = await permissionInfo.requestPermission(
          permission: permission,
        );
        if (!isGranted) {
          return false;
        }
      }

      bool? isAuthorized = await health.hasPermissions(
        _types,
        permissions: _permissions,
      );
      if (isAuthorized != true) {
        // request health permission
        isAuthorized = await health.requestAuthorization(
          _types,
          permissions: _permissions,
        );
      }
      Logger.success('requestPermission isAuthorized: $isAuthorized');

      return isAuthorized;
    } catch (error) {
      Logger.error('requestPermission error: $error');

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

      final result = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.SLEEP_SESSION,
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
}
