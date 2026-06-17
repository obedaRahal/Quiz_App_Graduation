// lib/features/other_profile/data/data_source/other_profile_remote_data_source.dart

import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart'; // تأكد من اسم الكلاس والمشروع لديك
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/content_bookmark_action_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/folder_bookmark_action_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_content_model.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_folder_details_model.dart';
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

  Future<FolderBookmarkActionModel> saveFolderBookmark({required int folderId});

  Future<FolderBookmarkActionModel> removeFolderBookmark({
    required int folderId,
  });

  Future<ContentBookmarkActionModel> saveContentBookmark({
    required int contentId,
  });

  Future<ContentBookmarkActionModel> removeContentBookmark({
    required int contentId,
  });

  Future<OtherProfileFolderDetailsModel> getOtherProfileFolderDetails({
    required int folderId,
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

  @override
  Future<FolderBookmarkActionModel> saveFolderBookmark({
    required int folderId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.saveFolderBookmark ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.folderBookmarkAction(folderId: folderId)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ params: {folderId: $folderId}");

    final response = await apiConsumer.post(
      EndPoints.folderBookmarkAction(folderId: folderId),
    );

    debugPrint("← response (saveFolderBookmark): $response");
    debugPrint("=================================================");

    return FolderBookmarkActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<FolderBookmarkActionModel> removeFolderBookmark({
    required int folderId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.removeFolderBookmark ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.folderBookmarkAction(folderId: folderId)}",
    );
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {folderId: $folderId}");

    final response = await apiConsumer.delete(
      EndPoints.folderBookmarkAction(folderId: folderId),
    );

    debugPrint("← response (removeFolderBookmark): $response");
    debugPrint("=================================================");

    return FolderBookmarkActionModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ContentBookmarkActionModel> saveContentBookmark({
    required int contentId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.saveContentBookmark ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.saveContentBookmark(contentId: contentId)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ params: {contentId: $contentId}");

    final response = await apiConsumer.post(
      EndPoints.saveContentBookmark(contentId: contentId),
    );

    debugPrint("← response (saveContentBookmark): $response");
    debugPrint("=================================================");

    return ContentBookmarkActionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<ContentBookmarkActionModel> removeContentBookmark({
    required int contentId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.removeContentBookmark ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.removeContentBookmark(contentId: contentId)}",
    );
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {contentId: $contentId}");

    final response = await apiConsumer.delete(
      EndPoints.removeContentBookmark(contentId: contentId),
    );

    debugPrint("← response (removeContentBookmark): $response");
    debugPrint("=================================================");

    return ContentBookmarkActionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OtherProfileFolderDetailsModel> getOtherProfileFolderDetails({
    required int folderId,
  }) async {
    debugPrint(
      "============ OtherProfileRemoteDataSourceImpl.getOtherProfileFolderDetails ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.otherProfileFolderDetails(folderId: folderId)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {folderId: $folderId}");

    final response = await apiConsumer.get(
      EndPoints.otherProfileFolderDetails(folderId: folderId),
    );

    debugPrint("← response (getOtherProfileFolderDetails): $response");
    debugPrint("=================================================");

    return OtherProfileFolderDetailsModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
