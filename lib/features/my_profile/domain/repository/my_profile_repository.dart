import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/delete_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_academic_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_scientific_interests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';

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
}
