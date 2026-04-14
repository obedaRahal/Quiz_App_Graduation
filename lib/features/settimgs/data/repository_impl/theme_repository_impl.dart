import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/settimgs/data/data_source/theme_local_data_source.dart';

import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    debugPrint("============ ThemeRepositoryImpl.saveThemeMode ============");

    await localDataSource.saveThemeMode(mode);
  }

  @override
  ThemeMode getThemeMode() {
    debugPrint("============ ThemeRepositoryImpl.getThemeMode ============");

    return localDataSource.getThemeMode();
  }
}
