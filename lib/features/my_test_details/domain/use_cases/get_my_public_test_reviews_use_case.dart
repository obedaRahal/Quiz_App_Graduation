import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_reviews_params.dart';

class GetMyPublicTestReviewsUseCase {
  final MyPublicTestDetailsRepository repository;

  const GetMyPublicTestReviewsUseCase(this.repository);

  Future<Either<Failure, MyPublicTestReviewsEntity>> call(
    GetMyPublicTestReviewsParams params,
  ) {
    debugPrint(
      "============ GetMyPublicTestReviewsUseCase.call ============",
    );
    debugPrint(
      "→ params: {testId: ${params.testId}, rating: ${params.rating}, page: ${params.page}}",
    );

    return repository.getMyPublicTestReviews(
      testId: params.testId,
      rating: params.rating,
      page: params.page,
    );
  }
}