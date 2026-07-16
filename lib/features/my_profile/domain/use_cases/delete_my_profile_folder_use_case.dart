import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_action_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/delete_my_profile_folder_params.dart';

class DeleteMyProfileFolderUseCase {
  final MyProfileRepository repository;

  const DeleteMyProfileFolderUseCase(this.repository);

  Future<Either<Failure, MyProfileFolderActionEntity>> call(
    DeleteMyProfileFolderParams params,
  ) {
    debugPrint(
      "============ DeleteMyProfileFolderUseCase.call ============",
    );
    debugPrint("→ folderId: ${params.folderId}");

    return repository.deleteMyProfileFolder(
      folderId: params.folderId,
    );
  }
}