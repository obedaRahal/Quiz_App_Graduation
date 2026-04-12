import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenExpiryAtKey = 'access_token_expiry_at';

  static Future<void> saveAccessToken({
    required String token,
    required int expiresInSeconds,
    String? refreshToken,
  }) async {
    final expiryAt = DateTime.now()
        .add(Duration(seconds: expiresInSeconds))
        .toIso8601String();

    await _secureStorage.write(key: _accessTokenKey, value: token);

    await _secureStorage.write(key: _accessTokenExpiryAtKey, value: expiryAt);

    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  static Future<DateTime?> getAccessTokenExpiry() async {
    final raw = await _secureStorage.read(key: _accessTokenExpiryAtKey);

    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  static Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> isAccessTokenExpiringSoon({
    Duration buffer = const Duration(minutes: 1),
  }) async {
    final expiry = await getAccessTokenExpiry();

    if (expiry == null) {
      return true;
    }

    return DateTime.now().isAfter(expiry.subtract(buffer));
  }

  static Future<bool> hasValidAccessToken({
    Duration buffer = Duration.zero,
  }) async {
    final token = await getAccessToken();
    final expiry = await getAccessTokenExpiry();

    if (token == null || token.isEmpty || expiry == null) {
      return false;
    }

    return DateTime.now().isBefore(expiry.subtract(buffer));
  }

  static Future<void> clear() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _accessTokenExpiryAtKey),
    ]);
  }
}
