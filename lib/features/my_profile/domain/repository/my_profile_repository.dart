import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_academic_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_scientific_interests_entity.dart';
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
}
