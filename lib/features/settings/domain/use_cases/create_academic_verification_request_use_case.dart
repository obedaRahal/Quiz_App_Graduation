import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/create_academic_verification_request_params.dart';

class CreateAcademicVerificationRequestUseCase {
  final SettingsRepository repository;

  const CreateAcademicVerificationRequestUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
    CreateAcademicVerificationRequestParams params,
  ) {
    debugPrint(
      '============ CreateAcademicVerificationRequestUseCase.call ============',
    );
    debugPrint(
      '→ certificateImagePath: '
      '${params.certificateImagePath}',
    );
    debugPrint('→ identityImagePath: ${params.identityImagePath}');
    debugPrint(
      '======================================================================',
    );

    return repository.createAcademicVerificationRequest(
      certificateImagePath: params.certificateImagePath,
      identityImagePath: params.identityImagePath,
    );
  }
}
