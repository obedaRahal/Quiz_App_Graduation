import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_folder_content_params.dart';

class FetchMyProfileFolderContentUseCase {
  final MyProfileRepository repository;

  const FetchMyProfileFolderContentUseCase(this.repository);

  Future<Either<Failure, MyProfileFolderContentEntity>> call(
    FetchMyProfileFolderContentParams params,
  ) {
    debugPrint(
      "============ FetchMyProfileFolderContentUseCase.call ============",
    );
    debugPrint("→ params: {folderId: ${params.folderId}}");

    return repository.fetchMyProfileFolderContent(folderId: params.folderId);
  }
}
