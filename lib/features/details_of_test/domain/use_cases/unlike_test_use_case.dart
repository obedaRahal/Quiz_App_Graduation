import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/test_like_action_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/test_like_action_params.dart';

class UnlikeTestUseCase {
  final DetailsOfTestRepository repository;

  const UnlikeTestUseCase(this.repository);

  Future<Either<Failure, TestLikeActionEntity>> call(
    TestLikeActionParams params,
  ) {
    debugPrint("============ UnlikeTestUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.unlikeTest(testId: params.testId);
  }
}