import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/delete_test_review_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/delete_test_review_params.dart';

class DeleteTestReviewUseCase {
  final DetailsOfTestRepository repository;

  const DeleteTestReviewUseCase(this.repository);

  Future<Either<Failure, DeleteTestReviewEntity>> call(
    DeleteTestReviewParams params,
  ) {
    debugPrint("============ DeleteTestReviewUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.deleteTestReview(
      testId: params.testId,
    );
  }
}