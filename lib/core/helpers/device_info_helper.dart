import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  String? _deviceId = '';
  String? _deviceModel = '';
  String? _deviceName = '';
  String? _releaseVersion = '';

  Future getDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final build = await plugin.androidInfo;
        _releaseVersion = build.version.release;
        _deviceId = build.id;
        _deviceModel = build.model.replaceAll(RegExp("[^a-zA-Z0-9 ]+"), "");
        _deviceName = "$_deviceModel, Android $_releaseVersion";
      } else if (Platform.isIOS) {
        final data = await plugin.iosInfo;
        _releaseVersion = data.systemVersion;
        _deviceId = data.identifierForVendor;
        _deviceModel = data.name.replaceAll(RegExp("[^a-zA-Z0-9 ]+"), "");
        _deviceName = "$_deviceModel, iOS $_releaseVersion";
      }
    } on PlatformException {
      log("Error when get device info");
    }
  }

  Future<String?> getDeviceId() async {
    if ((_deviceId ?? '').isEmpty) {
      await getDeviceInfo();
    }
    return _deviceId;
  }

  Future<String?> getDeviceName() async {
    if ((_deviceName ?? '').isEmpty) {
      await getDeviceInfo();
    }
    return _deviceName;
  }

  Future<String?> getDeviceModel() async {
    if ((_deviceModel ?? '').isEmpty) {
      await getDeviceInfo();
    }
    return _deviceModel;
  }

  Future<String?> getReleaseVersion() async {
    if ((_releaseVersion ?? '').isEmpty) {
      await getDeviceInfo();
    }
    return _releaseVersion;
  }
}
