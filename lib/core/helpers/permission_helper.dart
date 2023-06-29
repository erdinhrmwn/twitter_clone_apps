import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<void> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return;
    }

    if (await permission.isPermanentlyDenied) {
      log("ERROR: Permission denied\nPlease allow permission on settings app", name: "PermissionHelper");
      openAppSettings();
      return;
    }

    await permission.request();
  }

  static Future<void> requestPermissions(List<Permission> permissions) async {
    for (final permission in permissions) {
      await requestPermission(permission);
    }
  }
}
