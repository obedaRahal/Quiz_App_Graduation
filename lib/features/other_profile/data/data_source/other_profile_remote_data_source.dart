// lib/features/other_profile/data/data_source/other_profile_remote_data_source.dart

import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart'; // تأكد من اسم الكلاس والمشروع لديك
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_content_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_folders_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_overview_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_tests_model.dart';

abstract class OtherProfileRemoteDataSource {
  Future<OtherProfileOverviewModel> getOtherProfileOverview({
    required int userId,
  });

  Future<OtherProfileTestsResponseModel> getOtherProfileTests({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<OtherProfileFoldersResponseModel> getOtherProfileFolders({
    required int userId,
    String? cursor,
  });

  Future<OtherProfileContentResponseModel> getOtherProfileContent({
    required int userId,
    required String tab,
    String? cursor,
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

  @override
  Future<OtherProfileTestsResponseModel> getOtherProfileTests({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.getOtherProfileTests ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherProfileTests(userId: userId, tab: tab, cursor: cursor)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    final response = await apiConsumer.get(
      EndPoints.otherProfileTests(userId: userId, tab: tab, cursor: cursor),
    );

    debugPrint("← response (getOtherProfileTests): $response");
    debugPrint("=================================================");

    return OtherProfileTestsResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OtherProfileFoldersResponseModel> getOtherProfileFolders({
    required int userId,
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.getOtherProfileFolders ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherProfileFolders(userId: userId, cursor: cursor)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId, cursor: $cursor}");

    final response = await apiConsumer.get(
      EndPoints.otherProfileFolders(userId: userId, cursor: cursor),
    );

    debugPrint("← response (getOtherProfileFolders): $response");
    debugPrint("=================================================");

    return OtherProfileFoldersResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OtherProfileContentResponseModel> getOtherProfileContent({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.getOtherProfileContent ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherProfileContent(userId: userId, tab: tab, cursor: cursor)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    final response = await apiConsumer.get(
      EndPoints.otherProfileContent(userId: userId, tab: tab, cursor: cursor),
    );

    debugPrint("← response (getOtherProfileContent): $response");
    debugPrint("=================================================");

    return OtherProfileContentResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
