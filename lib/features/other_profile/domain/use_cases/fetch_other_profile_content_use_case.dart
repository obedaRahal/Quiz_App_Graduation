import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_content_params.dart';

class FetchOtherProfileContentUseCase {
  final OtherProfileRepository repository;

  const FetchOtherProfileContentUseCase(this.repository);

  Future<Either<Failure, OtherProfileContentResponseEntity>> call(
    FetchOtherProfileContentParams params,
  ) {
    debugPrint(
      "============ FetchOtherProfileContentUseCase.call ============",
    );
    debugPrint(
      "→ params: {userId: ${params.userId}, tab: ${params.tab}, cursor: ${params.cursor}}",
    );

    return repository.getOtherProfileContent(
      userId: params.userId,
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}
