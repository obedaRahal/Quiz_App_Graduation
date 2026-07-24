import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  const GetSettingsUseCase({required this.repository});

  Future<Either<Failure, SettingsEntity>> call() async {
    debugPrint('========== GetSettingsUseCase: START ==========');

    final result = await repository.getSettings();

    result.fold(
      (failure) {
        debugPrint('========== GetSettingsUseCase: FAILURE ==========');
        debugPrint('GetSettingsUseCase failure: ${failure.message}');
      },
      (settings) {
        debugPrint('========== GetSettingsUseCase: SUCCESS ==========');
        debugPrint(
          'taskRemindersEnabled: '
          '${settings.taskRemindersEnabled}',
        );
        debugPrint('weekStartsOn: ${settings.weekStartsOn}');
        debugPrint('timeFormat: ${settings.timeFormat}');
        debugPrint('themeMode: ${settings.themeMode}');
      },
    );

    return result;
  }
}
