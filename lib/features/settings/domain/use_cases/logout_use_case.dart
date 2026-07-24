import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';

class LogoutUseCase {
  final SettingsRepository repository;

  const LogoutUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required LogoutParams params}) {
    debugPrint("============ LogoutUseCase.call ============");
    debugPrint(
      "============ params is ${params.fcmToken} and ${params.deviceId} ============",
    );
    return repository.logout(params: params);
  }
}
