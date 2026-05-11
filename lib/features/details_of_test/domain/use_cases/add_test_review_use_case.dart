import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/add_test_review_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/add_test_review_params.dart';

class AddTestReviewUseCase {
  final DetailsOfTestRepository repository;

  const AddTestReviewUseCase(this.repository);

  Future<Either<Failure, AddTestReviewEntity>> call(
    AddTestReviewParams params,
  ) {
    debugPrint("============ AddTestReviewUseCase.call ============");
    debugPrint(
      "→ params: {testId: ${params.testId}, rating: ${params.rating}, reviewTextLength: ${params.reviewText.trim().length}}",
    );

    return repository.addTestReview(
      testId: params.testId,
      rating: params.rating,
      reviewText: params.reviewText,
    );
  }
}
