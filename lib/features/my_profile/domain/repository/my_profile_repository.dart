import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_action_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/delete_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_academic_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_scientific_interests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';

abstract class MyProfileRepository {
  Future<Either<Failure, MyProfileEntity>> getMyProfilePersonalInfo({
    required int userId,
  });

  Future<Either<Failure, EditMyProfilePersonalInfoEntity>>
  editMyProfilePersonalInfo({
    required int userId,
    required Map<String, dynamic> changedFields,
  });

  Future<Either<Failure, EditMyProfileAcademicInfoEntity>>
  editMyProfileAcademicInfo({
    required int userId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, EditMyProfileScientificInterestsEntity>>
  editMyProfileScientificInterests({
    required int userId,
    required List<int> interestIds,
  });

  Future<Either<Failure, EditMyProfilePictureEntity>> editMyProfilePicture({
    required int userId,
    required String type,
    required String imagePath,
  });

  Future<Either<Failure, DeleteMyProfilePictureEntity>> deleteMyProfilePicture({
    required int userId,
    required String type,
  });

  Future<Either<Failure, MyProfileBookmarksEntity>> fetchMyProfileBookmarks({
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, MyProfileLibraryEntity>> fetchMyProfileLibrary({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, MyProfileLibraryEntity>> searchMyProfileLibrary({
    required String query,
    required String mode,
    String? cursor,
  });

  Future<Either<Failure, MyProfileFoldersEntity>> fetchMyProfileFolders({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, MyProfileFolderContentEntity>>
  fetchMyProfileFolderContent({required int folderId});

  Future<Either<Failure, MyProfilePickerTestsEntity>>
  fetchMyProfilePickerTests({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, MyProfilePickerSearchTestsEntity>>
  fetchMyProfilePickerSearchTests({required String query, int page});

  Future<Either<Failure, MyProfileFolderActionEntity>> createMyProfileFolder({
    required Map<String, dynamic> body,
  });

  Future<Either<Failure, MyProfileFolderActionEntity>> updateMyProfileFolder({
    required int folderId,
    required Map<String, dynamic> body,
  });

  Future<Either<Failure, MyProfileFolderActionEntity>> deleteMyProfileFolder({
    required int folderId,
  });

  Future<Either<Failure, MyProfileFilteredTestsEntity>> filterMyProfileTests({
    required Map<String, dynamic> queryParameters,
  });
}
