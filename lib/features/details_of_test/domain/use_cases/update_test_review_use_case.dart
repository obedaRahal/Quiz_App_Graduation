import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_review_action_entity.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/update_test_review_params.dart';

class UpdateTestReviewUseCase {
  final DetailsOfTestRepository repository;

  const UpdateTestReviewUseCase(this.repository);

  Future<Either<Failure, UpdateTestReviewEntity>> call(
    UpdateTestReviewParams params,
  ) {
    debugPrint("============ UpdateTestReviewUseCase.call ============");
    debugPrint(
      "→ params: {testId: ${params.testId}, rating: ${params.rating}, reviewTextLength: ${params.reviewText.trim().length}}",
    );

    return repository.updateTestReview(
      testId: params.testId,
      rating: params.rating,
      reviewText: params.reviewText,
    );
  }
}
