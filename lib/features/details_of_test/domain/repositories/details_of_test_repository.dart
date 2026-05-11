import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/add_test_review_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/download_test_file_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_follow_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_like_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_review_action_entity.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_overview_entity.dart';

abstract class DetailsOfTestRepository {
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
  getOtherTestDetailsOverview({required int testId});

  Future<Either<Failure, OtherTestDetailsSampleEntity>>
  getOtherTestDetailsSample({required int testId});

  Future<Either<Failure, OtherTestDetailsReviewsEntity>>
  getOtherTestDetailsReviews({required int testId, required String rating});

  Future<Either<Failure, TestLikeActionEntity>> likeTest({required int testId});

  Future<Either<Failure, TestLikeActionEntity>> unlikeTest({
    required int testId,
  });

  Future<Either<Failure, TestBookmarkActionEntity>> bookmarkTest({
    required int testId,
  });

  Future<Either<Failure, TestBookmarkActionEntity>> unbookmarkTest({
    required int testId,
  });

  Future<Either<Failure, TestFollowActionEntity>> followCreator({
    required int creatorId,
  });

  Future<Either<Failure, TestFollowActionEntity>> unfollowCreator({
    required int creatorId,
  });

  Future<Either<Failure, DownloadTestFileEntity>> downloadTestFile({
    required int testId,
  });

  Future<Either<Failure, AddTestReviewEntity>> addTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  });

  Future<Either<Failure, UpdateTestReviewEntity>> updateTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  });
}
