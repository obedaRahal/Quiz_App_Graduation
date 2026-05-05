import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_overview_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/get_other_test_details_overview_params.dart';

class GetOtherTestDetailsOverviewUseCase {
  final DetailsOfTestRepository repository;

  const GetOtherTestDetailsOverviewUseCase(this.repository);

  Future<Either<Failure, OtherTestDetailsOverviewEntity>> call(
    GetOtherTestDetailsOverviewParams params,
  ) {
    debugPrint(
      "============ GetOtherTestDetailsOverviewUseCase.call ============",
    );
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.getOtherTestDetailsOverview(
      testId: params.testId,
    );
  }
}