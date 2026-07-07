import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/delete_my_profile_picture_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/edit_my_profile_academic_info_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/edit_my_profile_personal_info_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/edit_my_profile_picture_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/edit_my_profile_scientific_interests_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_bookmarks_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folders_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_library_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_personal_info_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/search_my_profile_library_model.dart';

abstract class MyProfileRemoteDataSource {
  Future<MyProfilePersonalInfoModel> getMyProfilePersonalInfo({
    required int userId,
  });

  Future<EditMyProfilePersonalInfoModel> editMyProfilePersonalInfo({
    required int userId,
    required Map<String, dynamic> changedFields,
  });

  Future<EditMyProfileAcademicInfoModel> editMyProfileAcademicInfo({
    required int userId,
    required Map<String, dynamic> data,
  });

  Future<EditMyProfileScientificInterestsModel>
  editMyProfileScientificInterests({
    required int userId,
    required List<int> interestIds,
  });

  Future<EditMyProfilePictureModel> editMyProfilePicture({
    required int userId,
    required String type,
    required String imagePath,
  });

  Future<DeleteMyProfilePictureModel> deleteMyProfilePicture({
    required int userId,
    required String type,
  });

  Future<MyProfileBookmarksModel> fetchMyProfileBookmarks({
    required String tab,
    String? cursor,
  });

  Future<MyProfileLibraryModel> fetchMyProfileLibrary({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<SearchMyProfileLibraryModel> searchMyProfileLibrary({
    required String query,
    required String mode,
    String? cursor,
  });

  Future<MyProfileFoldersModel> fetchMyProfileFolders({
    required int userId,
    required String tab,
    String? cursor,
  });
}

class MyProfileRemoteDataSourceImpl implements MyProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  const MyProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<MyProfilePersonalInfoModel> getMyProfilePersonalInfo({
    required int userId,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.getMyProfilePersonalInfo ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.myProfilePersonalInfo(userId: userId)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId}");

    final response = await apiConsumer.get(
      EndPoints.myProfilePersonalInfo(userId: userId),
    );

    debugPrint("← response (getMyProfilePersonalInfo): $response");
    debugPrint("=================================================");

    return MyProfilePersonalInfoModel.fromJson(
      userId: userId,
      json: (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<EditMyProfilePersonalInfoModel> editMyProfilePersonalInfo({
    required int userId,
    required Map<String, dynamic> changedFields,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.editMyProfilePersonalInfo ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.editMyProfilePersonalInfo(userId: userId)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ body: $changedFields");

    final response = await apiConsumer.post(
      EndPoints.editMyProfilePersonalInfo(userId: userId),
      data: changedFields,
    );

    debugPrint("← response (editMyProfilePersonalInfo): $response");
    debugPrint("=================================================");

    return EditMyProfilePersonalInfoModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<EditMyProfileAcademicInfoModel> editMyProfileAcademicInfo({
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.editMyProfileAcademicInfo ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.editMyProfileAcademicInfo(userId: userId)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ body: $data");

    final response = await apiConsumer.post(
      EndPoints.editMyProfileAcademicInfo(userId: userId),
      data: data,
      isFormData: true,
    );

    debugPrint("← response (editMyProfileAcademicInfo): $response");
    debugPrint("=================================================");

    return EditMyProfileAcademicInfoModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<EditMyProfileScientificInterestsModel>
  editMyProfileScientificInterests({
    required int userId,
    required List<int> interestIds,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.editMyProfileScientificInterests ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.editMyProfileScientificInterests(userId: userId)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ body: {interest_ids: $interestIds}");

    final response = await apiConsumer.post(
      EndPoints.editMyProfileScientificInterests(userId: userId),
      data: {'interest_ids': interestIds},
    );

    debugPrint("← response (editMyProfileScientificInterests): $response");
    debugPrint("=================================================");

    return EditMyProfileScientificInterestsModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<EditMyProfilePictureModel> editMyProfilePicture({
    required int userId,
    required String type,
    required String imagePath,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.editMyProfilePicture ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.editMyProfilePicture(userId: userId, type: type)}",
    );
    debugPrint("→ method: POST");
    debugPrint("→ imagePath: $imagePath");

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(imagePath),
    });

    final response = await apiConsumer.post(
      EndPoints.editMyProfilePicture(userId: userId, type: type),
      data: formData,
      isFormData: true,
    );

    debugPrint("← response (editMyProfilePicture): $response");
    debugPrint("=================================================");

    return EditMyProfilePictureModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<DeleteMyProfilePictureModel> deleteMyProfilePicture({
    required int userId,
    required String type,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.deleteMyProfilePicture ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.deleteMyProfilePicture(userId: userId, type: type)}",
    );
    debugPrint("→ method: DELETE");

    final response = await apiConsumer.delete(
      EndPoints.deleteMyProfilePicture(userId: userId, type: type),
    );

    debugPrint("← response (deleteMyProfilePicture): $response");
    debugPrint("=================================================");

    return DeleteMyProfilePictureModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<MyProfileBookmarksModel> fetchMyProfileBookmarks({
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfileBookmarks ============",
    );

    final endpoint = EndPoints.myProfileBookmarks(tab: tab, cursor: cursor);

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (fetchMyProfileBookmarks): $response");
    debugPrint("=================================================");

    return MyProfileBookmarksModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<MyProfileLibraryModel> fetchMyProfileLibrary({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfileLibrary ============",
    );

    final endpoint = EndPoints.myProfileLibrary(
      userId: userId,
      tab: tab,
      cursor: cursor,
    );

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (fetchMyProfileLibrary): $response");
    debugPrint("=================================================");

    return MyProfileLibraryModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SearchMyProfileLibraryModel> searchMyProfileLibrary({
    required String query,
    required String mode,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.searchMyProfileLibrary ============",
    );

    final endpoint = EndPoints.searchMyProfileLibrary(
      query: query,
      mode: mode,
      cursor: cursor,
    );

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: GET");

    final response = await apiConsumer.get(endpoint);

    debugPrint("← response (searchMyProfileLibrary): $response");
    debugPrint("=================================================");

    return SearchMyProfileLibraryModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<MyProfileFoldersModel> fetchMyProfileFolders({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfileFolders ============",
    );

    debugPrint(
      "→ endpoint: ${EndPoints.myProfileFolders(userId: userId, tab: tab, cursor: cursor)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    final response = await apiConsumer.get(
      EndPoints.myProfileFolders(userId: userId, tab: tab, cursor: cursor),
    );

    debugPrint("← response (fetchMyProfileFolders): $response");
    debugPrint("=================================================");

    return MyProfileFoldersModel.fromJson(response as Map<String, dynamic>);
  }
}
