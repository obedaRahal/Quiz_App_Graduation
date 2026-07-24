import 'package:flutter/services.dart';

class AppSystemSettingsService {
  AppSystemSettingsService._();

  static const MethodChannel _channel = MethodChannel(
    'quiz_app_grad/system_settings',
  );

  static Future<void> openNotificationSettings() {
    return _channel.invokeMethod<void>('openNotificationSettings');
  }
}
