// lib/features/other_profile/domain/use_cases/fetch_other_profile_overview_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_overview_params.dart';
import '../entities/other_profile_overview_entity.dart';

class FetchOtherProfileOverviewUseCase {
  final OtherProfileRepository repository;

  const FetchOtherProfileOverviewUseCase(this.repository);

  Future<Either<Failure, OtherProfileOverviewEntity>> call(
    FetchOtherProfileOverviewParams params,
  ) {
    debugPrint(
      "============ FetchOtherProfileOverviewUseCase.call ============",
    );
    debugPrint("→ params: {userId: ${params.userId}}");

    return repository.getOtherProfileOverview(userId: params.userId);
  }
}