// lib/features/other_profile/domain/use_cases/fetch_other_profile_tests_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_tests_params.dart';
import '../entities/other_profile_tests_entity.dart';

class FetchOtherProfileTestsUseCase {
  final OtherProfileRepository repository;

  const FetchOtherProfileTestsUseCase(this.repository);

  Future<Either<Failure, OtherProfileTestsResponseEntity>> call(
    FetchOtherProfileTestsParams params,
  ) {
    debugPrint("============ FetchOtherProfileTestsUseCase.call ============");
    debugPrint(
      "→ params: {userId: ${params.userId}, tab: ${params.tab}, cursor: ${params.cursor}}",
    );

    return repository.getOtherProfileTests(
      userId: params.userId,
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}
