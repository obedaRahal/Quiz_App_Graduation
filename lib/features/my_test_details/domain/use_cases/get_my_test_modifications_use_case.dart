import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_test_modifications_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_test_modifications_params.dart';

class GetMyTestModificationsUseCase {
  final MyPublicTestDetailsRepository repository;

  const GetMyTestModificationsUseCase(this.repository);

  Future<Either<Failure, MyTestModificationsEntity>> call(
    GetMyTestModificationsParams params,
  ) {
    debugPrint(
      "============ GetMyTestModificationsUseCase.call ============",
    );
    debugPrint(
      "→ params: {testId: ${params.testId}, roundId: ${params.roundId}}",
    );

    return repository.getMyTestModifications(
      testId: params.testId,
      roundId: params.roundId,
    );
  }
}