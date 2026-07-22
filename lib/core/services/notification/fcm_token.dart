import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

class FcmTokenStorage {
  static const _fcmTokenKey = 'fcm_token';

  static Future<void> saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await CacheHelper.saveData(key: _fcmTokenKey, value: token);
  }

  static String? getToken() {
    return CacheHelper.getData(key: _fcmTokenKey);
  }

  static Future<void> clear() async {
    await CacheHelper.removeData(key: _fcmTokenKey);
  }
}
