import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_action_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/create_my_profile_folder_params.dart';

class CreateMyProfileFolderUseCase {
  final MyProfileRepository repository;

  const CreateMyProfileFolderUseCase(this.repository);

  Future<Either<Failure, MyProfileFolderActionEntity>> call(
    CreateMyProfileFolderParams params,
  ) {
    debugPrint("============ CreateMyProfileFolderUseCase.call ============");
    debugPrint("→ body: ${params.toBody()}");

    return repository.createMyProfileFolder(
      body: params.toBody(),
    );
  }
}