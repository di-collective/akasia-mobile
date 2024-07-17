import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/utils/permission_info.dart';

abstract class HealthService {
  Future<bool?> requestPermission();
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
}
