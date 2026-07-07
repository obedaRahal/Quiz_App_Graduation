import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_folders_params.dart';

class FetchMyProfileFoldersUseCase {
  final MyProfileRepository repository;

  const FetchMyProfileFoldersUseCase(this.repository);

  Future<Either<Failure, MyProfileFoldersEntity>> call(
    FetchMyProfileFoldersParams params,
  ) {
    debugPrint("============ FetchMyProfileFoldersUseCase.call ============");
    debugPrint(
      "→ params: {userId: ${params.userId}, tab: ${params.tab}, cursor: ${params.cursor}}",
    );

    return repository.fetchMyProfileFolders(
      userId: params.userId,
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}