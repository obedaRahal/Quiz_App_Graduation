import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/add_test_review_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/download_test_file_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_bookmark_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_follow_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_like_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_reviews_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_sample_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/update_test_review_model.dart';

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
}
