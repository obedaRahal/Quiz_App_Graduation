import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_action_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/update_my_profile_folder_params.dart';

class UpdateMyProfileFolderUseCase {
  final MyProfileRepository repository;

  const UpdateMyProfileFolderUseCase(this.repository);

  Future<Either<Failure, MyProfileFolderActionEntity>> call(
    UpdateMyProfileFolderParams params,
  ) {
    debugPrint("============ UpdateMyProfileFolderUseCase.call ============");
    debugPrint("→ folderId: ${params.folderId}");
    debugPrint("→ body: ${params.toBody()}");

    return repository.updateMyProfileFolder(
      folderId: params.folderId,
      body: params.toBody(),
    );
  }
}