import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/add_test_review_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/delete_test_review_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/download_test_file_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/review_feedback_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_follow_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_like_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_review_action_entity.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/other_test_details_overview_entity.dart';
import '../../domain/repositories/details_of_test_repository.dart';
import '../data_sources/details_of_test_remote_data_source.dart';

class DetailsOfTestRepositoryImpl implements DetailsOfTestRepository {
  final DetailsOfTestRemoteDataSource remoteDataSource;

  const DetailsOfTestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
  getOtherTestDetailsOverview({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsOverview");

      final model = await remoteDataSource.getOtherTestDetailsOverview(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsOverview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OtherTestDetailsSampleEntity>>
  getOtherTestDetailsSample({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsSample");

      final model = await remoteDataSource.getOtherTestDetailsSample(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsSample success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OtherTestDetailsReviewsEntity>>
  getOtherTestDetailsReviews({
    required int testId,
    required String rating,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews ============",
    );
    debugPrint("→ params: {testId: $testId, rating: $rating}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsReviews");

      final model = await remoteDataSource.getOtherTestDetailsReviews(
        testId: testId,
        rating: rating,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsReviews success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestLikeActionEntity>> likeTest({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.likeTest ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.likeTest");

      final model = await remoteDataSource.likeTest(testId: testId);

      debugPrint("← remoteDataSource.likeTest success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.likeTest ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.likeTest CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ DetailsOfTestRepositoryImpl.likeTest Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestLikeActionEntity>> unlikeTest({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.unlikeTest ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.unlikeTest");

      final model = await remoteDataSource.unlikeTest(testId: testId);

      debugPrint("← remoteDataSource.unlikeTest success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unlikeTest ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unlikeTest CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unlikeTest Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestBookmarkActionEntity>> bookmarkTest({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.bookmarkTest ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.bookmarkTest");

      final model = await remoteDataSource.bookmarkTest(testId: testId);

      debugPrint("← remoteDataSource.bookmarkTest success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.bookmarkTest ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.bookmarkTest CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.bookmarkTest Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestBookmarkActionEntity>> unbookmarkTest({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.unbookmarkTest ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.unbookmarkTest");

      final model = await remoteDataSource.unbookmarkTest(testId: testId);

      debugPrint("← remoteDataSource.unbookmarkTest success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unbookmarkTest ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unbookmarkTest CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unbookmarkTest Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestFollowActionEntity>> followCreator({
    required int creatorId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.followCreator ============",
    );
    debugPrint("→ params: {creatorId: $creatorId}");

    try {
      debugPrint("→ calling remoteDataSource.followCreator");

      final model = await remoteDataSource.followCreator(creatorId: creatorId);

      debugPrint("← remoteDataSource.followCreator success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.followCreator ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.followCreator Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, TestFollowActionEntity>> unfollowCreator({
    required int creatorId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.unfollowCreator ============",
    );
    debugPrint("→ params: {creatorId: $creatorId}");

    try {
      debugPrint("→ calling remoteDataSource.unfollowCreator");

      final model = await remoteDataSource.unfollowCreator(
        creatorId: creatorId,
      );

      debugPrint("← remoteDataSource.unfollowCreator success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unfollowCreator ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.unfollowCreator Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, DownloadTestFileEntity>> downloadTestFile({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.downloadTestFile ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.downloadTestFile");

      final model = await remoteDataSource.downloadTestFile(testId: testId);

      debugPrint("← remoteDataSource.downloadTestFile success");
      debugPrint("→ filePath: ${model.filePath}");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.downloadTestFile ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.downloadTestFile Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تحميل ملف الاختبار'),
      );
    }
  }

  @override
  Future<Either<Failure, AddTestReviewEntity>> addTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.addTestReview ============",
    );
    debugPrint(
      "→ params: {testId: $testId, rating: $rating, reviewTextLength: ${reviewText.trim().length}}",
    );

    try {
      debugPrint("→ calling remoteDataSource.addTestReview");

      final model = await remoteDataSource.addTestReview(
        testId: testId,
        rating: rating,
        reviewText: reviewText,
      );

      debugPrint("← remoteDataSource.addTestReview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addTestReview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addTestReview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addTestReview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(ServerFailure(title: 'حدث خطأ', message: 'تعذر نشر التقييم'));
    }
  }

  @override
  Future<Either<Failure, UpdateTestReviewEntity>> updateTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.updateTestReview ============",
    );
    debugPrint(
      "→ params: {testId: $testId, rating: $rating, reviewTextLength: ${reviewText.trim().length}}",
    );

    try {
      debugPrint("→ calling remoteDataSource.updateTestReview");

      final model = await remoteDataSource.updateTestReview(
        testId: testId,
        rating: rating,
        reviewText: reviewText,
      );

      debugPrint("← remoteDataSource.updateTestReview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.updateTestReview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.updateTestReview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.updateTestReview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تعديل التقييم'),
      );
    }
  }

  @override
  Future<Either<Failure, DeleteTestReviewEntity>> deleteTestReview({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.deleteTestReview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.deleteTestReview");

      final model = await remoteDataSource.deleteTestReview(testId: testId);

      debugPrint("← remoteDataSource.deleteTestReview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteTestReview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteTestReview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteTestReview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف التقييم'));
    }
  }

  @override
  Future<Either<Failure, ReviewFeedbackActionEntity>> addFeedbackOnReview({
    required int reviewId,
    required String vote,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.addFeedbackOnReview ============",
    );
    debugPrint("→ params: {reviewId: $reviewId, vote: $vote}");

    try {
      debugPrint("→ calling remoteDataSource.addFeedbackOnReview");

      final model = await remoteDataSource.addFeedbackOnReview(
        reviewId: reviewId,
        vote: vote,
      );

      debugPrint("← remoteDataSource.addFeedbackOnReview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addFeedbackOnReview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addFeedbackOnReview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.addFeedbackOnReview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تسجيل رأيك على المراجعة',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewFeedbackActionEntity>> deleteFeedbackOnReview({
    required int reviewId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.deleteFeedbackOnReview ============",
    );
    debugPrint("→ params: {reviewId: $reviewId}");

    try {
      debugPrint("→ calling remoteDataSource.deleteFeedbackOnReview");

      final model = await remoteDataSource.deleteFeedbackOnReview(
        reviewId: reviewId,
      );

      debugPrint("← remoteDataSource.deleteFeedbackOnReview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteFeedbackOnReview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteFeedbackOnReview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.deleteFeedbackOnReview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر إزالة رأيك عن المراجعة'),
      );
    }
  }
}
