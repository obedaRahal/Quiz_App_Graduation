import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_private_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_private_test_details_overview_params.dart';

class GetMyPrivateTestDetailsOverviewUseCase {
  final MyPublicTestDetailsRepository repository;

  const GetMyPrivateTestDetailsOverviewUseCase(this.repository);

  Future<Either<Failure, MyPrivateTestDetailsOverviewEntity>> call(
    GetMyPrivateTestDetailsOverviewParams params,
  ) {
    debugPrint(
      "============ GetMyPrivateTestDetailsOverviewUseCase.call ============",
    );
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.getMyPrivateTestDetailsOverview(
      testId: params.testId,
    );
  }
}