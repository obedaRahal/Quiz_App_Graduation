import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class EnableTaskRemindersUseCase {
  final SettingsRepository repository;

  const EnableTaskRemindersUseCase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    debugPrint("========== EnableTaskRemindersUseCase: START ==========");

    final result = await repository.enableTaskReminders();

    result.fold(
      (failure) {
        debugPrint("========== EnableTaskRemindersUseCase: FAILURE ==========");
      },
      (_) {
        debugPrint("========== EnableTaskRemindersUseCase: SUCCESS ==========");
      },
    );

    return result;
  }
}
