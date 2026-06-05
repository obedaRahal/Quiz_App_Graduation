import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';

abstract class MyPublicTestDetailsRepository {
  Future<Either<Failure, MyPublicTestDetailsOverviewEntity>>
  getMyPublicTestDetailsOverview({required int testId});

  Future<Either<Failure, MyPublicTestStatusHistoryEntity>>
  getMyPublicTestStatusHistory({required int testId});

  Future<Either<Failure, MyPublicTestReviewsEntity>> getMyPublicTestReviews({
  required int testId,
  required String rating,
  required int page,
});
}
