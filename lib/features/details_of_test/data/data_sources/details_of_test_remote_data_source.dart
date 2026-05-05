import 'package:flutter/foundation.dart';

import '../../../../core/database/api/api_consumer.dart';
import '../../../../core/database/api/end_point.dart';
import '../models/other_test_details_overview_model.dart';

abstract class DetailsOfTestRemoteDataSource {
  Future<OtherTestDetailsOverviewModel> getOtherTestDetailsOverview({
    required int testId,
  });
}

class DetailsOfTestRemoteDataSourceImpl
    implements DetailsOfTestRemoteDataSource {
  final ApiConsumer apiConsumer;

  const DetailsOfTestRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<OtherTestDetailsOverviewModel> getOtherTestDetailsOverview({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestRemoteDataSourceImpl.getOtherTestDetailsOverview ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherTestDetailsOverview(testId)}",
    );
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
}