import 'dart:convert';
import 'dart:io';


import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/core/service/push_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/util/util.dart';
import 'package:package_info/package_info.dart';

class SetConfigService extends BaseService {
  Api _apiService;
  ConfigData config;

  SetConfigService() {
    this.config = ConfigData();
    this._apiService = locator.get<Api>();
  }

  setConfig() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var deviceInfo = await Util.deviceInfo();
      config.version = packageInfo.version;
      config.buildNumber = packageInfo.buildNumber;
      if (Platform.isIOS) {
        config.platform = 'ios';
        config.osVersion = deviceInfo['systemVersion'];
      } else {
        config.platform = 'android';
        config.osVersion = deviceInfo['version.release'];
      }
      config.device = deviceInfo['model'];
      config.pushToken = locator.get<PushService>().token;

      var result = await _apiService.post('user/set-config', config.toString());
      print(result);
    } catch (e) {
      print('Firebase error: ' + e.toString());
    }
  }
}

class ConfigData {
  String pushToken;
  String platform;
  String device;
  String buildNumber;
  String version;
  String osVersion;

  ConfigData({this.pushToken, this.buildNumber, this.device, this.platform, this.version, this.osVersion});

  Map<String, String> toJson() {
    var map = new Map<String, String>();
    map['push_token'] = pushToken;
    map['platform'] = platform;
    map['device'] = device;
    map['build_number'] = buildNumber;
    map['version'] = version;
    map['os_version'] = osVersion;
    return map;
  }

  factory ConfigData.fromJson(Map<String, dynamic> json) {
    return ConfigData(
        pushToken: json['pushToken'] as String,
        platform: json['platform'] as String,
        device: json['device'] as String,
        version: json['version'] as String,
        osVersion: json['os_version'] as String,
        buildNumber: json['buildNumber'] as String);
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
