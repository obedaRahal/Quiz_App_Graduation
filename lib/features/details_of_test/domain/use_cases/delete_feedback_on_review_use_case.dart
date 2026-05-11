import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review_feedback_action_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/delete_review_feedback_params.dart';

class DeleteFeedbackOnReviewUseCase {
  final DetailsOfTestRepository repository;

  const DeleteFeedbackOnReviewUseCase(this.repository);

  Future<Either<Failure, ReviewFeedbackActionEntity>> call(
    DeleteReviewFeedbackParams params,
  ) {
    debugPrint("============ DeleteFeedbackOnReviewUseCase.call ============");
    debugPrint("→ params: {reviewId: ${params.reviewId}}");

    return repository.deleteFeedbackOnReview(
      reviewId: params.reviewId,
    );
  }
}