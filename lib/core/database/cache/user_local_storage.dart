import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLocalStorage {
  UserLocalStorage._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userGenderKey = 'user_gender';

  static Future<void> saveUserInfo({
    required int id,
    required String name,
    required String gender,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _userIdKey, value: id.toString()),
      _secureStorage.write(key: _userNameKey, value: name),
      _secureStorage.write(key: _userGenderKey, value: gender),
    ]);
  }

  static Future<int?> getUserId() async {
    final storedId = await _secureStorage.read(key: _userIdKey);
    final userId = int.tryParse(storedId ?? '');
    return userId != null && userId > 0 ? userId : null;
  }

  static Future<String?> getUserName() {
    return _secureStorage.read(key: _userNameKey);
  }

  static Future<String?> getUserGender() {
    return _secureStorage.read(key: _userGenderKey);
  }

  static Future<void> clear() async {
    await Future.wait([
      _secureStorage.delete(key: _userIdKey),
      _secureStorage.delete(key: _userNameKey),
      _secureStorage.delete(key: _userGenderKey),
    ]);
  }
}
