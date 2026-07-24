import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_date_time_params.dart';

class UpdateDateTimeUseCase {
  final SettingsRepository repository;

  const UpdateDateTimeUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required UpdateDateTimeParams params}) {
    debugPrint("============ UpdateDateTimeUseCase.call ============");
    debugPrint(
      "============ params is ${params.timeFormat} and ${params.weekStartsOn} ============",
    );

    return repository.updateDateTime(params: params);
  }
}
