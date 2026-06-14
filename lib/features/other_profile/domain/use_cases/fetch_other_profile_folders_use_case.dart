import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_folders_params.dart';

class FetchOtherProfileFoldersUseCase {
  final OtherProfileRepository repository;

  const FetchOtherProfileFoldersUseCase(this.repository);

  Future<Either<Failure, OtherProfileFoldersResponseEntity>> call(
    FetchOtherProfileFoldersParams params,
  ) {
    debugPrint(
      "============ FetchOtherProfileFoldersUseCase.call ============",
    );
    debugPrint(
      "→ params: {userId: ${params.userId}, cursor: ${params.cursor}}",
    );

    return repository.getOtherProfileFolders(
      userId: params.userId,
      cursor: params.cursor,
    );
  }
}
