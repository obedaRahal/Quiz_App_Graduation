import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_folder_details_params.dart';

class FetchOtherProfileFolderDetailsUseCase {
  final OtherProfileRepository repository;

  const FetchOtherProfileFolderDetailsUseCase(this.repository);

  Future<Either<Failure, OtherProfileFolderDetailsEntity>> call(
    FetchOtherProfileFolderDetailsParams params,
  ) {
    debugPrint(
      "============ FetchOtherProfileFolderDetailsUseCase.call ============",
    );
    debugPrint("→ params: {folderId: ${params.folderId}}");

    return repository.getOtherProfileFolderDetails(
      folderId: params.folderId,
    );
  }
}