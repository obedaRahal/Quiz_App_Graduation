import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

abstract class ThemeLocalDataSource {
  Future<void> saveThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    debugPrint("============ ThemeLocalDataSource.saveThemeMode ============");
    await CacheHelper.saveData(key: _themeModeKey, value: mode.name);
  }

  @override
  ThemeMode getThemeMode() {
    debugPrint("============ ThemeLocalDataSource.getThemeMode ============");
    final storedValue = CacheHelper.getString(key: _themeModeKey);

    switch (storedValue) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}
