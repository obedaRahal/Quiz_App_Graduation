import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/add_test_review_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/stripe_checkout_session_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_interaction_users_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/delete_test_review_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/download_test_file_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/review_feedback_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/shared_test_link_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/submit_report_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_follow_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_like_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_review_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_share_link_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_state.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_overview_entity.dart';

abstract class DetailsOfTestRepository {
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
  getOtherTestDetailsOverview({required int testId});

  Future<Either<Failure, OtherTestDetailsSampleEntity>>
  getOtherTestDetailsSample({required int testId});

  Future<Either<Failure, OtherTestDetailsReviewsEntity>>
  getOtherTestDetailsReviews({
    required int testId,
    required String rating,
    required int page,
  });

  Future<Either<Failure, TestLikeActionEntity>> likeTest({required int testId});

  Future<Either<Failure, TestLikeActionEntity>> unlikeTest({
    required int testId,
  });

  Future<Either<Failure, TestBookmarkActionEntity>> bookmarkTest({
    required int testId,
  });

  Future<Either<Failure, TestBookmarkActionEntity>> unBookmarkTest({
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

  Future<Either<Failure, DeleteTestReviewEntity>> deleteTestReview({
    required int testId,
  });

  Future<Either<Failure, ReviewFeedbackActionEntity>> addFeedbackOnReview({
    required int reviewId,
    required String vote,
  });

  Future<Either<Failure, ReviewFeedbackActionEntity>> deleteFeedbackOnReview({
    required int reviewId,
  });

  Future<Either<Failure, SubmitReportEntity>> submitReport({
    required ReportTargetType targetType,
    required int targetId,
    required String reason,
    required String description,
  });

  Future<Either<Failure, TestShareLinkEntity>> getTestShareLink({
    required int testId,
  });

  Future<Either<Failure, SharedTestLinkEntity>> getSharedTestLink({
    required String slug,
  });

  Future<Either<Failure, TestInteractionUsersEntity>> getTestInteractionUsers({
    required int testId,
    required TestInteractionUsersType type,
    String search = '',
    String? cursor,
  });

  Future<Either<Failure, StripeCheckoutSessionEntity>>
  createStripeCheckoutSession({required int testId});
}
