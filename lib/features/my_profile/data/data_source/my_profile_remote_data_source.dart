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
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_filtered_tests_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_action_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_content_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folders_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_library_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_personal_info_model.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_picker_tests_model.dart';
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

  Future<MyProfileFolderContentModel> fetchMyProfileFolderContent({
    required int folderId,
  });

  Future<MyProfilePickerTestsModel> fetchMyProfilePickerTests({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<MyProfilePickerSearchTestsModel> fetchMyProfilePickerSearchTests({
    required String query,
    int page,
  });

  Future<MyProfileFolderActionModel> createMyProfileFolder({
    required Map<String, dynamic> body,
  });

  Future<MyProfileFolderActionModel> updateMyProfileFolder({
    required int folderId,
    required Map<String, dynamic> body,
  });

  Future<MyProfileFolderActionModel> deleteMyProfileFolder({
    required int folderId,
  });

  Future<MyProfileFilteredTestsModel> filterMyProfileTests({
    required Map<String, dynamic> queryParameters,
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

  @override
  Future<MyProfileFolderContentModel> fetchMyProfileFolderContent({
    required int folderId,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfileFolderContent ============",
    );
    debugPrint("→ endpoint: ${EndPoints.myProfileFolderContent(folderId)}");
    debugPrint("→ method: GET");
    debugPrint("→ params: {folderId: $folderId}");

    final response = await apiConsumer.get(
      EndPoints.myProfileFolderContent(folderId),
    );

    debugPrint("← response (fetchMyProfileFolderContent): $response");
    debugPrint("=================================================");

    return MyProfileFolderContentModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyProfilePickerTestsModel> fetchMyProfilePickerTests({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfilePickerTests ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.myProfilePickerTests(userId: userId, tab: tab, cursor: cursor)}",
    );
    debugPrint("→ method: GET");
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    final response = await apiConsumer.get(
      EndPoints.myProfilePickerTests(userId: userId, tab: tab, cursor: cursor),
    );

    debugPrint("← response (fetchMyProfilePickerTests): $response");
    debugPrint("=================================================");

    return MyProfilePickerTestsModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<MyProfilePickerSearchTestsModel> fetchMyProfilePickerSearchTests({
    required String query,
    int page = 1,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.fetchMyProfilePickerSearchTests ============",
    );
    debugPrint("→ endpoint: ${EndPoints.myProfilePickerSearchTests()}");
    debugPrint("→ method: POST");
    debugPrint("→ body: {q: $query, page: $page}");

    final response = await apiConsumer.post(
      EndPoints.myProfilePickerSearchTests(),
      data: {'q': query, 'page': page},
    );

    debugPrint("← response (fetchMyProfilePickerSearchTests): $response");
    debugPrint("=================================================");

    return MyProfilePickerSearchTestsModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyProfileFolderActionModel> createMyProfileFolder({
    required Map<String, dynamic> body,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.createMyProfileFolder ============",
    );
    debugPrint("→ endpoint: ${EndPoints.createMyProfileFolder()}");
    debugPrint("→ method: POST");
    debugPrint("→ body: $body");

    final response = await apiConsumer.post(
      EndPoints.createMyProfileFolder(),
      data: body,
    );

    debugPrint("← response (createMyProfileFolder): $response");
    debugPrint("=================================================");

    return MyProfileFolderActionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyProfileFolderActionModel> updateMyProfileFolder({
    required int folderId,
    required Map<String, dynamic> body,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.updateMyProfileFolder ============",
    );
    debugPrint("→ endpoint: ${EndPoints.updateMyProfileFolder(folderId)}");
    debugPrint("→ method: POST");
    debugPrint("→ body: $body");

    final response = await apiConsumer.post(
      EndPoints.updateMyProfileFolder(folderId),
      data: body,
    );

    debugPrint("← response (updateMyProfileFolder): $response");
    debugPrint("=================================================");

    return MyProfileFolderActionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyProfileFolderActionModel> deleteMyProfileFolder({
    required int folderId,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.deleteMyProfileFolder ============",
    );
    debugPrint("→ endpoint: ${EndPoints.deleteMyProfileFolder(folderId)}");
    debugPrint("→ method: DELETE");
    debugPrint("→ params: {folderId: $folderId}");

    final response = await apiConsumer.delete(
      EndPoints.deleteMyProfileFolder(folderId),
    );

    debugPrint("← response (deleteMyProfileFolder): $response");
    debugPrint("=================================================");

    return MyProfileFolderActionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MyProfileFilteredTestsModel> filterMyProfileTests({
    required Map<String, dynamic> queryParameters,
  }) async {
    debugPrint(
      "============ MyProfileRemoteDataSourceImpl.filterMyProfileTests ============",
    );
    debugPrint("→ endpoint: ${EndPoints.filterMyProfileTests}");
    debugPrint("→ method: GET");
    debugPrint("→ queryParameters: $queryParameters");

    final response = await apiConsumer.get(
      EndPoints.filterMyProfileTests,
      queryParameters: queryParameters,
    );

    debugPrint("← response (filterMyProfileTests): $response");
    debugPrint("=================================================");

    return MyProfileFilteredTestsModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
