import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_bookmark_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/test_like_action_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_reviews_model.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/other_test_details_sample_model.dart';

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
}

class DetailsOfTestRemoteDataSourceImpl
    implements DetailsOfTestRemoteDataSource {
  final ApiConsumer apiConsumer;

  const DetailsOfTestRemoteDataSourceImpl({required this.apiConsumer});

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
}
