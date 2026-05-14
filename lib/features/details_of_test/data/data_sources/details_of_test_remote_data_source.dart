import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/add_test_review_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/delete_test_review_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/download_test_file_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/review_feedback_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/submit_report_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_bookmark_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_follow_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_like_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_reviews_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_sample_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_share_link_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/update_test_review_model.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/api/api_consumer.dart';
import '../../../../core/database/api/end_point.dart';
import '../models/other_test_details_overview_model.dart';

abstract class DetailsOfTestRemoteDataSource {
  Future<OtherTestDetailsOverviewModel> getOtherTestDetailsOverview({
    required int testId,
  });

  Future<OtherTestDetailsSampleModel> getOtherTestDetailsSample({
    required int testId,
  });

  Future<OtherTestDetailsReviewsModel> getOtherTestDetailsReviews({
    required int testId,
    required String rating,
  });
  Future<TestLikeActionModel> likeTest({required int testId});

  Future<TestLikeActionModel> unlikeTest({required int testId});

  Future<TestBookmarkActionModel> bookmarkTest({required int testId});

  Future<TestBookmarkActionModel> unbookmarkTest({required int testId});

  Future<TestFollowActionModel> followCreator({required int creatorId});

  Future<TestFollowActionModel> unfollowCreator({required int creatorId});

  Future<DownloadTestFileModel> downloadTestFile({required int testId});

  Future<AddTestReviewModel> addTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  });

  Future<UpdateTestReviewModel> updateTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  });

  Future<DeleteTestReviewModel> deleteTestReview({required int testId});

  Future<ReviewFeedbackActionModel> addFeedbackOnReview({
    required int reviewId,
    required String vote,
  });

  Future<ReviewFeedbackActionModel> deleteFeedbackOnReview({
    required int reviewId,
  });

  Future<SubmitReportModel> submitReport({
    required ReportTargetType targetType,
    required int targetId,
    required String reason,
    required String description,
  });

  Future<TestShareLinkModel> getTestShareLink({required int testId});
}

class DetailsOfTestRemoteDataSourceImpl
    implements DetailsOfTestRemoteDataSource {
  final ApiConsumer apiConsumer;
  final Dio dio;

  const DetailsOfTestRemoteDataSourceImpl({
    required this.apiConsumer,
    required this.dio,
  });

  @override
  Future<OtherTestDetailsOverviewModel> getOtherTestDetailsOverview({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.getOtherTestDetailsOverview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsOverview(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.get(
      EndPoints.otherTestDetailsOverview(testId),
    );

    debugPrint("← response (getOtherTestDetailsOverview): $response");
    debugPrint("=================================================");

    return OtherTestDetailsOverviewModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OtherTestDetailsSampleModel> getOtherTestDetailsSample({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.getOtherTestDetailsSample ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsSample(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.get(
      EndPoints.otherTestDetailsSample(testId),
    );

    debugPrint("← response (getOtherTestDetailsSample): $response");
    debugPrint("=================================================");

    return OtherTestDetailsSampleModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OtherTestDetailsReviewsModel> getOtherTestDetailsReviews({
    required int testId,
    required String rating,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.getOtherTestDetailsReviews ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherTestDetailsReviews(testId: testId, rating: rating)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId, rating: $rating}");

    final response = await apiConsumer.get(
      EndPoints.otherTestDetailsReviews(testId: testId, rating: rating),
    );

    debugPrint("← response (getOtherTestDetailsReviews): $response");
    debugPrint("=================================================");

    return OtherTestDetailsReviewsModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<TestLikeActionModel> likeTest({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.likeTest ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsLike(testId)}");
    debugPrint("→ method: POST");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.post(
      EndPoints.otherTestDetailsLike(testId),
    );

    debugPrint("← response (likeTest): $response");
    debugPrint("=================================================");

    return TestLikeActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestLikeActionModel> unlikeTest({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.unlikeTest ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsUnlike(testId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.delete(
      EndPoints.otherTestDetailsUnlike(testId),
    );

    debugPrint("← response (unlikeTest): $response");
    debugPrint("=================================================");

    return TestLikeActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestBookmarkActionModel> bookmarkTest({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.bookmarkTest ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsBookmark(testId)}");
    debugPrint("→ method: POST");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.post(
      EndPoints.otherTestDetailsBookmark(testId),
    );

    debugPrint("← response (bookmarkTest): $response");
    debugPrint("=================================================");

    return TestBookmarkActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestBookmarkActionModel> unbookmarkTest({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.unbookmarkTest ============",
    );
    debugPrint("→ endpoint: ${EndPoints.otherTestDetailsUnbookmark(testId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.delete(
      EndPoints.otherTestDetailsUnbookmark(testId),
    );

    debugPrint("← response (unbookmarkTest): $response");
    debugPrint("=================================================");

    return TestBookmarkActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestFollowActionModel> followCreator({required int creatorId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.followCreator ============",
    );
    debugPrint("→ endpoint: ${EndPoints.followCreator(creatorId)}");
    debugPrint("→ method: POST");
    debugPrint("→ params: {creatorId: $creatorId}");

    final response = await apiConsumer.post(EndPoints.followCreator(creatorId));

    debugPrint("← response (followCreator): $response");
    debugPrint("=================================================");

    return TestFollowActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestFollowActionModel> unfollowCreator({
    required int creatorId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.unfollowCreator ============",
    );
    debugPrint("→ endpoint: ${EndPoints.unfollowCreator(creatorId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {creatorId: $creatorId}");

    final response = await apiConsumer.delete(
      EndPoints.unfollowCreator(creatorId),
    );

    debugPrint("← response (unfollowCreator): $response");
    debugPrint("=================================================");

    return TestFollowActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<DownloadTestFileModel> downloadTestFile({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.downloadTestFile ============",
    );
    debugPrint("→ endpoint: ${EndPoints.downloadTestFile(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final directory = await getApplicationDocumentsDirectory();

    final fileName = 'test_$testId.pdf';
    final filePath = '${directory.path}/$fileName';

    debugPrint("→ target filePath: $filePath");

    final response = await dio.download(
      EndPoints.downloadTestFile(testId),
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    debugPrint("← download statusCode: ${response.statusCode}");
    debugPrint("← saved filePath: $filePath");
    debugPrint("=================================================");

    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('لم يتم حفظ ملف الاختبار');
    }

    return DownloadTestFileModel(filePath: filePath, fileName: fileName);
  }

  @override
  Future<AddTestReviewModel> addTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.addTestReview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.addTestReview(testId)}");
    debugPrint("→ method: POST");
    debugPrint(
      "→ body: {rating: $rating, review_text_length: ${reviewText.trim().length}}",
    );

    final response = await apiConsumer.post(
      EndPoints.addTestReview(testId),
      data: {'rating': rating, 'review_text': reviewText.trim()},
    );

    debugPrint("← response (addTestReview): $response");
    debugPrint("=================================================");

    return AddTestReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UpdateTestReviewModel> updateTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.updateTestReview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.updateTestReview(testId)}");
    debugPrint("→ method: POST");
    debugPrint(
      "→ body: {rating: $rating, review_text_length: ${reviewText.trim().length}}",
    );

    final response = await apiConsumer.post(
      EndPoints.updateTestReview(testId),
      data: {'rating': rating, 'review_text': reviewText.trim()},
    );

    debugPrint("← response (updateTestReview): $response");
    debugPrint("=================================================");

    return UpdateTestReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<DeleteTestReviewModel> deleteTestReview({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.deleteTestReview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.deleteTestReview(testId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.delete(
      EndPoints.deleteTestReview(testId),
    );

    debugPrint("← response (deleteTestReview): $response");
    debugPrint("=================================================");

    return DeleteTestReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ReviewFeedbackActionModel> addFeedbackOnReview({
    required int reviewId,
    required String vote,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.addFeedbackOnReview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.addFeedbackOnReview(reviewId)}");
    debugPrint("→ method: POST");
    debugPrint("→ body: {vote: $vote}");

    final response = await apiConsumer.post(
      EndPoints.addFeedbackOnReview(reviewId),
      data: {'vote': vote},
    );

    debugPrint("← response (addFeedbackOnReview): $response");
    debugPrint("=================================================");

    return ReviewFeedbackActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ReviewFeedbackActionModel> deleteFeedbackOnReview({
    required int reviewId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.deleteFeedbackOnReview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.deleteFeedbackOnReview(reviewId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {reviewId: $reviewId}");

    final response = await apiConsumer.delete(
      EndPoints.deleteFeedbackOnReview(reviewId),
    );

    debugPrint("← response (deleteFeedbackOnReview): $response");
    debugPrint("=================================================");

    return ReviewFeedbackActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<SubmitReportModel> submitReport({
    required ReportTargetType targetType,
    required int targetId,
    required String reason,
    required String description,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.submitReport ============",
    );

    final endpoint = switch (targetType) {
      ReportTargetType.review => EndPoints.reportReview(targetId),
      ReportTargetType.test => EndPoints.reportTest(targetId),
    };

    final idempotencyKey = const Uuid().v4();

    debugPrint("→ targetType: ${targetType.name}");
    debugPrint("→ targetId: $targetId");
    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: POST");
    debugPrint("→ idempotencyKey: $idempotencyKey");
    debugPrint(
      "→ body: {reason: $reason, descriptionLength: ${description.trim().length}}",
    );

    final response = await apiConsumer.post(
      endpoint,
      data: {'reason': reason, 'description': description.trim()},
      headers: {'Idempotency-Key': idempotencyKey},
    );

    debugPrint("← response (submitReport): $response");
    debugPrint("=================================================");

    return SubmitReportModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<TestShareLinkModel> getTestShareLink({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.getTestShareLink ============",
    );
    debugPrint("→ endpoint: ${EndPoints.testShareLink(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.get(EndPoints.testShareLink(testId));

    debugPrint("← response (getTestShareLink): $response");
    debugPrint("=================================================");

    return TestShareLinkModel.fromJson(response as Map<String, dynamic>);
  }
}
