import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  static const String appLocaleKey = 'app_locale';
  static const String themeModeKey = 'theme_mode';
  static const String hasSeenIntroKey = 'has_seen_intro';


  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefs {
    if (_sharedPreferences == null) {
      throw const CacheException(
        errorMessage:
            'CacheHelper is not initialized. Call CacheHelper.init() first.',
      );
    }
    return _sharedPreferences!;
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    try {
      if (value is bool) {
        return await _prefs.setBool(key, value);
      } else if (value is String) {
        return await _prefs.setString(key, value);
      } else if (value is int) {
        return await _prefs.setInt(key, value);
      } else if (value is double) {
        return await _prefs.setDouble(key, value);
      } else if (value is List<String>) {
        return await _prefs.setStringList(key, value);
      } else {
        throw const CacheException(
          errorMessage: 'Unsupported value type for CacheHelper.saveData',
        );
      }
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(
        errorMessage: 'Failed to save data for key "$key": $e',
      );
    }
  }

  static dynamic getData({required String key}) {
    return _prefs.get(key);
  }

  static String? getString({required String key}) {
    return _prefs.getString(key);
  }

  static bool? getBool({required String key}) {
    return _prefs.getBool(key);
  }

  static int? getInt({required String key}) {
    return _prefs.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _prefs.getDouble(key);
  }

  static List<String>? getStringList({required String key}) {
    return _prefs.getStringList(key);
  }

  static Future<bool> removeData({required String key}) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw CacheException(
        errorMessage: 'Failed to remove data for key "$key": $e',
      );
    }
  }

  static bool containsKey({required String key}) {
    return _prefs.containsKey(key);
  }

  static Future<bool> clearData() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw CacheException(
        errorMessage: 'Failed to clear cache data: $e',
      );
    }
  }

  static Future<void> clearDataExcept({
    List<String> keysToKeep = const [],
  }) async {
    try {
      final preservedValues = <String, dynamic>{};

      for (final key in keysToKeep) {
        if (_prefs.containsKey(key)) {
          preservedValues[key] = _prefs.get(key);
        }
      }

      await _prefs.clear();

      for (final entry in preservedValues.entries) {
        await saveData(
          key: entry.key,
          value: entry.value,
        );
      }
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(
        errorMessage: 'Failed to clear cache while preserving some keys: $e',
      );
    }
  }

  static Future<void> clearDataButKeepSettings() async {
    await clearDataExcept(
      keysToKeep: const [
        appLocaleKey,
        themeModeKey,
      ],
    );
  }
}