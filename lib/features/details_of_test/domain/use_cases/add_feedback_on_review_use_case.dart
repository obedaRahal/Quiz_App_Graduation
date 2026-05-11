import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review_feedback_action_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/review_feedback_action_params.dart';

class AddFeedbackOnReviewUseCase {
  final DetailsOfTestRepository repository;

  const AddFeedbackOnReviewUseCase(this.repository);

  Future<Either<Failure, ReviewFeedbackActionEntity>> call(
    ReviewFeedbackActionParams params,
  ) {
    debugPrint("============ AddFeedbackOnReviewUseCase.call ============");
    debugPrint(
      "→ params: {reviewId: ${params.reviewId}, vote: ${params.vote}}",
    );

    return repository.addFeedbackOnReview(
      reviewId: params.reviewId,
      vote: params.vote,
    );
  }
}