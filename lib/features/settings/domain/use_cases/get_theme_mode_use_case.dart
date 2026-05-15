import 'package:flutter/material.dart';

import '../repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository repository;

  GetThemeModeUseCase(this.repository);

  ThemeMode call() {
    debugPrint("============ GetThemeModeUseCase.call ============");

    return repository.getThemeMode();
  }
}
