import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_reviews_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/get_other_test_details_reviews_params.dart';

class GetOtherTestDetailsReviewsUseCase {
  final DetailsOfTestRepository repository;

  const GetOtherTestDetailsReviewsUseCase(this.repository);

  Future<Either<Failure, OtherTestDetailsReviewsEntity>> call(
    GetOtherTestDetailsReviewsParams params,
  ) {
    debugPrint(
      "============ GetOtherTestDetailsReviewsUseCase.call ============",
    );
    debugPrint(
      "→ params: {testId: ${params.testId}, rating: ${params.rating}, page: ${params.page}}",
    );

    return repository.getOtherTestDetailsReviews(
      testId: params.testId,
      rating: params.rating,
      page: params.page,
    );
  }
}
