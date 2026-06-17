import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/folder_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/folder_bookmark_action_params.dart';

class RemoveFolderBookmarkUseCase {
  final OtherProfileRepository repository;

  const RemoveFolderBookmarkUseCase(this.repository);

  Future<Either<Failure, FolderBookmarkActionEntity>> call(
    FolderBookmarkActionParams params,
  ) {
    debugPrint("============ RemoveFolderBookmarkUseCase.call ============");
    debugPrint("→ params: {folderId: ${params.folderId}}");

    return repository.removeFolderBookmark(folderId: params.folderId);
  }
}