import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_status_history_params.dart';

class GetMyPublicTestStatusHistoryUseCase {
  final MyPublicTestDetailsRepository repository;

  const GetMyPublicTestStatusHistoryUseCase(this.repository);

  Future<Either<Failure, MyPublicTestStatusHistoryEntity>> call(
    GetMyPublicTestStatusHistoryParams params,
  ) {
    debugPrint(
      "============ GetMyPublicTestStatusHistoryUseCase.call ============",
    );
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.getMyPublicTestStatusHistory(testId: params.testId);
  }
}
