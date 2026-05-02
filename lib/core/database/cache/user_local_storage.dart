import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLocalStorage {
  UserLocalStorage._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _userNameKey = 'user_name';
  static const String _userGenderKey = 'user_gender';

  static Future<void> saveUserInfo({
    required String name,
    required String gender,
  }) async {
    await _secureStorage.write(key: _userNameKey, value: name);
    await _secureStorage.write(key: _userGenderKey, value: gender);
  }

  static Future<String?> getUserName() {
    return _secureStorage.read(key: _userNameKey);
  }

  static Future<String?> getUserGender() {
    return _secureStorage.read(key: _userGenderKey);
  }

  static Future<void> clear() async {
    await Future.wait([
      _secureStorage.delete(key: _userNameKey),
      _secureStorage.delete(key: _userGenderKey),
    ]);
  }
}