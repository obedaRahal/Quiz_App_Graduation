import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_academic_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_academic_info_params.dart';

class EditMyProfileAcademicInfoUseCase {
  final MyProfileRepository repository;

  const EditMyProfileAcademicInfoUseCase(this.repository);

  Future<Either<Failure, EditMyProfileAcademicInfoEntity>> call(
    EditMyProfileAcademicInfoParams params,
  ) {
    debugPrint(
      "============ EditMyProfileAcademicInfoUseCase.call ============",
    );
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ data: ${params.data}");

    return repository.editMyProfileAcademicInfo(
      userId: params.userId,
      data: params.data,
    );
  }
}
