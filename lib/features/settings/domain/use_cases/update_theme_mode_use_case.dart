import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class UpdateThemeModeUseCase {
  final SettingsRepository repository;

  const UpdateThemeModeUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required String themeMode}) async {
    debugPrint("========== UpdateThemeModeUseCase: START ==========");

    debugPrint("themeMode: $themeMode");

    final result = await repository.updateThemeMode(themeMode: themeMode);

    result.fold(
      (failure) {
        debugPrint("========== UpdateThemeModeUseCase: FAILURE ==========");
      },
      (_) {
        debugPrint("========== UpdateThemeModeUseCase: SUCCESS ==========");
      },
    );

    return result;
  }
}
