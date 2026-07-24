import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class DisableTaskRemindersUseCase {
  final SettingsRepository repository;

  const DisableTaskRemindersUseCase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    debugPrint("========== DisableTaskRemindersUseCase: START ==========");

    final result = await repository.disableTaskReminders();

    result.fold(
      (failure) {
        debugPrint(
          "========== DisableTaskRemindersUseCase: FAILURE ==========",
        );
      },
      (_) {
        debugPrint(
          "========== DisableTaskRemindersUseCase: SUCCESS ==========",
        );
      },
    );

    return result;
  }
}
