import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class CancelAcademicVerificationRequestUseCase {
  final SettingsRepository repository;

  const CancelAcademicVerificationRequestUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    debugPrint(
      '============ CancelAcademicVerificationRequestUseCase.call ============',
    );
    debugPrint(
      '========================================================================',
    );

    return repository.cancelAcademicVerificationRequest();
  }
}
