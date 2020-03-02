import 'package:flutter/services.dart';

typedef HlmChannelHandle = Future<dynamic> Function(MethodCall call);

class HlmPlugin{
  static HlmPlugin _instance;
  static const CHANNEL_NAME = 'com.huifu.hlm/flutterPlugin';
  MethodChannel _channel;

  factory HlmPlugin() => _shareInstance();

  static _shareInstance() {
    if (_instance == null) {
      _instance = HlmPlugin._();
    }
    return _instance;
  }

  HlmPlugin._() {
    _channel = _channel = MethodChannel(CHANNEL_NAME)
    ..setMethodCallHandler(_nativeMethodHandler);
  }

  Future<dynamic> _nativeMethodHandler(MethodCall call) {
    switch(call.method) {
      //todo
      case "hlm_flutter_test": {
        return Future.value({"code" : 200, "data" : {"name" : "Mr. Smith", "from" : "Flutter"}});
      }
    }

    return Future.value();
  }

  Future<String> getApiBaseUrl() async {
    Map res = await _channel.invokeMethod("hlm_getApiUrl");
    return res['baseUrl'];
  }

  Future<AppInfo> getAppInfo() async {
    Map res = await _channel.invokeMethod("hlm_getAppInfo");
    return AppInfo.fromMap(res);
  }

  Future<DeviceInfo> getDeviceInfo() async {
    Map res = await _channel.invokeMethod("hlm_getDeviceInfo");
    return DeviceInfo.fromMap(res);
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    Map<String, dynamic> res = await _channel.invokeMethod("hlm_getUserInfo");
    return res;
  }

  Future<Map<dynamic, dynamic>> apiSign(Map<dynamic, dynamic> queries) async {
    Map<dynamic, dynamic> res = await _channel.invokeMethod("hlm_apiSign", queries);
    return res;
  }

  Future disableNavigatorPop() {
    return _channel.invokeMethod("hlm_pop_disable");
  }

  Future enableNavigatorPop() {
    return _channel.invokeMethod("hlm_pop_enable");
  }
}


class AppInfo {
  String _appVersion;
  String _buildVersion;
  String _appType;
  String _appPlatform;
  String _appChannel;

  get appVersion => _appVersion;
  get buildVersion => _buildVersion;
  get appType => _appType;
  get appPlatform => _appPlatform;
  get appChannel => _appChannel;

  AppInfo.fromMap(Map map) {
    if(map != null) {
      _appVersion = map['app_version'];
      _buildVersion = map['app_build_version'];
      _appType = map['app_type'];
      _appPlatform = map['app_platform'];
      _appChannel = map['app_channel'];
    }
  }
}

class DeviceInfo {
  String _deviceVersion;
  String _deviceModel;
  String _ip;
  String _deviceUUID;
  String _deviceNum;

  get deviceVersion => _deviceVersion;
  get deviceModel => _deviceModel;
  get ip => _ip;
  get deviceUUID => _deviceUUID;
  get deviceNum => _deviceNum;

  DeviceInfo.fromMap(Map map) {
    if(map != null) {
      _deviceVersion = map['device_version'];
      _deviceModel = map['device_model'];
      _ip = map['ip'];
      _deviceUUID = map['device_uuid'];
      _deviceNum = map['device_no'];
    }
  }
}