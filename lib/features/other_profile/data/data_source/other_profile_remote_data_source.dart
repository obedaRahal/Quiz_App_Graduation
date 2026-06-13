// lib/features/other_profile/data/data_source/other_profile_remote_data_source.dart

import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart'; // تأكد من اسم الكلاس والمشروع لديك
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_overview_model.dart';

abstract class OtherProfileRemoteDataSource {
  Future<OtherProfileOverviewModel> getOtherProfileOverview({
    required int userId,
  });
}

class OtherProfileRemoteDataSourceImpl implements OtherProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  const OtherProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OtherProfileOverviewModel> getOtherProfileOverview({
    required int userId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.getOtherProfileOverview ============",
    );

    debugPrint("→ endpoint: ${EndPoints.otherProfileOverview(userId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId}");

    final response = await apiConsumer.get(
      EndPoints.otherProfileOverview(userId),
    );

    debugPrint("← response (getOtherProfileOverview): $response");
    debugPrint("=================================================");

    return OtherProfileOverviewModel.fromJson(response as Map<String, dynamic>);
  }
}
