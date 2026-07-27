import 'package:flutter/services.dart';

class AppSystemSettingsService {
  AppSystemSettingsService._();

  static const MethodChannel _channel = MethodChannel(
    'com.nerd.app/system_settings',
  );

  static Future<void> openNotificationSettings() {
    return _channel.invokeMethod<void>('openNotificationSettings');
  }
}
