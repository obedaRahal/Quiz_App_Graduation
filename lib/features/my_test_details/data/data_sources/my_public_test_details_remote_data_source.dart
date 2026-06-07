import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/my_test_details/data/models/my_private_test_details_overview_model.dart';
import 'package:quiz_app_grad/features/my_test_details/data/models/my_public_test_details_overview_model.dart';
import 'package:quiz_app_grad/features/my_test_details/data/models/my_public_test_reviews_model.dart';
import 'package:quiz_app_grad/features/my_test_details/data/models/my_public_test_status_history_model.dart';
import 'package:quiz_app_grad/features/my_test_details/data/models/my_test_modifications_model.dart';

abstract class MyPublicTestDetailsRemoteDataSource {
  Future<MyPublicTestDetailsOverviewModel> getMyPublicTestDetailsOverview({
    required int testId,
  });

  Future<MyPublicTestStatusHistoryModel> getMyPublicTestStatusHistory({
    required int testId,
  });

  Future<MyPublicTestReviewsModel> getMyPublicTestReviews({
    required int testId,
    required String rating,
    required int page,
  });

  Future<MyTestModificationsModel> getMyTestModifications({
    required int testId,
    required int roundId,
  });

  Future<MyPrivateTestDetailsOverviewModel> getMyPrivateTestDetailsOverview({
    required int testId,
  });
}

class MyPublicTestDetailsRemoteDataSourceImpl
    implements MyPublicTestDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  const MyPublicTestDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MyPublicTestDetailsOverviewModel> getMyPublicTestDetailsOverview({
    required int testId,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRemoteDataSourceImpl.getMyPublicTestDetailsOverview ============",
    );
    debugPrint("→ endpoint: ${EndPoints.myPublicTestDetailsOverview(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.get(
      EndPoints.myPublicTestDetailsOverview(testId),
    );

    debugPrint("← response (getMyPublicTestDetailsOverview): $response");
    debugPrint("=================================================");

    return MyPublicTestDetailsOverviewModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyPublicTestStatusHistoryModel> getMyPublicTestStatusHistory({
    required int testId,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRemoteDataSourceImpl.getMyPublicTestStatusHistory ============",
    );
    debugPrint("→ endpoint: ${EndPoints.myPublicTestStatusHistory(testId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId}");

    final response = await apiConsumer.get(
      EndPoints.myPublicTestStatusHistory(testId),
    );

    debugPrint("← response (getMyPublicTestStatusHistory): $response");
    debugPrint("=================================================");

    return MyPublicTestStatusHistoryModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyPublicTestReviewsModel> getMyPublicTestReviews({
    required int testId,
    required String rating,
    required int page,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRemoteDataSourceImpl.getMyPublicTestReviews ============",
    );

    final endpoint = EndPoints.myPublicTestReviews(
      testId: testId,
      rating: rating,
      page: page,
    );

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId, rating: $rating, page: $page}");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (getMyPublicTestReviews): $response");
    debugPrint("=================================================");

    return MyPublicTestReviewsModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<MyTestModificationsModel> getMyTestModifications({
    required int testId,
    required int roundId,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRemoteDataSourceImpl.getMyTestModifications ============",
    );

    final endpoint = EndPoints.myTestModifications(
      testId: testId,
      roundId: roundId,
    );

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");
    debugPrint("→ params: {testId: $testId, roundId: $roundId}");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (getMyTestModifications): $response");
    debugPrint("=================================================");

    return MyTestModificationsModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<MyPrivateTestDetailsOverviewModel> getMyPrivateTestDetailsOverview({
    required int testId,
  }) async {
    debugPrint(
      "============ MyPrivateTestDetailsRemoteDataSourceImpl.getMyPrivateTestDetailsOverview ============",
    );

    final endpoint = EndPoints.myPrivateTestDetailsOverview(testId);
    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (getMyPrivateTestDetailsOverview): $response");
    debugPrint("=================================================");

    return MyPrivateTestDetailsOverviewModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
