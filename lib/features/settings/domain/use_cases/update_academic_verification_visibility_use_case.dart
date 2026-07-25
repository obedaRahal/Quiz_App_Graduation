import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_academic_verification_visibility_params.dart';

class UpdateAcademicVerificationVisibilityUseCase {
  final SettingsRepository repository;

  const UpdateAcademicVerificationVisibilityUseCase(
    this.repository,
  );

  Future<Either<Failure, Unit>> call(
    UpdateAcademicVerificationVisibilityParams params,
  ) {
    debugPrint(
      '============ UpdateAcademicVerificationVisibilityUseCase.call ============',
    );
    debugPrint(
      '→ showCertificatePublicly: '
      '${params.showCertificatePublicly}',
    );
    debugPrint(
      '============================================================================',
    );

    return repository
        .updateAcademicVerificationVisibility(
          showCertificatePublicly:
              params.showCertificatePublicly,
        );
  }
}