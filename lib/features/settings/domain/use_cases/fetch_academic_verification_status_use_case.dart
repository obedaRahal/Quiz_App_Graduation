import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';

class FetchAcademicVerificationStatusUseCase {
  final SettingsRepository repository;

  const FetchAcademicVerificationStatusUseCase(this.repository);

  Future<Either<Failure, AcademicVerificationEntity>> call() {
    debugPrint(
      '============ FetchAcademicVerificationStatusUseCase.call ============',
    );
    debugPrint(
      '=====================================================================',
    );

    return repository.fetchAcademicVerificationStatus();
  }
}
