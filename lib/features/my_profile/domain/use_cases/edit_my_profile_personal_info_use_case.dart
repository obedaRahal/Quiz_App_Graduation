import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_personal_info_params.dart';

class EditMyProfilePersonalInfoUseCase {
  final MyProfileRepository repository;

  const EditMyProfilePersonalInfoUseCase(this.repository);

  Future<Either<Failure, EditMyProfilePersonalInfoEntity>> call(
    EditMyProfilePersonalInfoParams params,
  ) {
    debugPrint(
      "============ EditMyProfilePersonalInfoUseCase.call ============",
    );
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ changedFields: ${params.changedFields}");

    return repository.editMyProfilePersonalInfo(
      userId: params.userId,
      changedFields: params.changedFields,
    );
  }
}