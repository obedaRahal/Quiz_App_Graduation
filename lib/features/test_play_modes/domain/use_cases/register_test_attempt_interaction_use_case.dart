import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/register_test_attempt_interaction_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/repositories/test_play_modes_repository.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/register_test_attempt_interaction_params.dart';

class RegisterTestAttemptInteractionUseCase {
  final TestPlayModesRepository repository;

  const RegisterTestAttemptInteractionUseCase(this.repository);

  Future<Either<Failure, RegisterTestAttemptInteractionEntity>> call(
    RegisterTestAttemptInteractionParams params,
  ) {
    debugPrint(
      "============ RegisterTestAttemptInteractionUseCase.call ============",
    );
    debugPrint(
      "→ params: {testId: ${params.testId}, mode: ${params.mode.apiValue}}",
    );

    return repository.registerTestAttemptInteraction(
      testId: params.testId,
      mode: params.mode.apiValue,
    );
  }
}