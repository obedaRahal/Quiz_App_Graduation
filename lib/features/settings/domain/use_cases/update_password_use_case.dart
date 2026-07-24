import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_password_params.dart';

class UpdatePasswordUseCase {
  final SettingsRepository repository;

  const UpdatePasswordUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required UpdatePasswordParams params}) {
    debugPrint("============ UpdatePasswordUseCase.call ============");
    debugPrint(
      "============ params is ${params.oldPassword} and ${params.newPassword} and ${params.newPasswordConfirmation} ============",
    );
    return repository.updatePassword(params: params);
  }
}
