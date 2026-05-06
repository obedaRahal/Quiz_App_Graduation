import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_overview_entity.dart';

abstract class DetailsOfTestRepository {
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
  getOtherTestDetailsOverview({required int testId});

  Future<Either<Failure, OtherTestDetailsSampleEntity>>
  getOtherTestDetailsSample({required int testId});

  Future<Either<Failure, OtherTestDetailsReviewsEntity>>
  getOtherTestDetailsReviews({required int testId, required String rating});
}
