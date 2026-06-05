import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_details_overview_params.dart';

class GetMyPublicTestDetailsOverviewUseCase {
  final MyPublicTestDetailsRepository repository;

  const GetMyPublicTestDetailsOverviewUseCase(this.repository);

  Future<Either<Failure, MyPublicTestDetailsOverviewEntity>> call(
    GetMyPublicTestDetailsOverviewParams params,
  ) {
    debugPrint(
      "============ GetMyPublicTestDetailsOverviewUseCase.call ============",
    );
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.getMyPublicTestDetailsOverview(testId: params.testId);
  }
}
