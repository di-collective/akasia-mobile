import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';

abstract class PermissionInfo {
  Future<bool> get directoryPermission;
}

class PermissionInfoImpl implements PermissionInfo {
  @override
  Future<bool> get directoryPermission async {
    try {
      Logger.info('directoryPermission');

      PermissionStatus permissionStatus = await Permission.storage.status;
      Logger.success('directoryPermission permissionStatus: $permissionStatus');

      if (!permissionStatus.isGranted) {
        permissionStatus = await Permission.storage.request();
        Logger.success(
            'directoryPermission permissionStatus: $permissionStatus');
      }

      return permissionStatus.isGranted;
    } catch (error) {
      Logger.error('directoryPermission error: $error');

      rethrow;
    }
  }
}
