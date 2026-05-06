import 'package:flutter/foundation.dart';
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
}
