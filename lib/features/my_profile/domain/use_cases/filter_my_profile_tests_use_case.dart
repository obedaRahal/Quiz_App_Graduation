import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/filter_my_profile_tests_params.dart';

class FilterMyProfileTestsUseCase {
  final MyProfileRepository repository;

  const FilterMyProfileTestsUseCase(this.repository);

  Future<Either<Failure, MyProfileFilteredTestsEntity>> call(
    FilterMyProfileTestsParams params,
  ) {
    debugPrint(
      "============ FilterMyProfileTestsUseCase.call ============",
    );
    debugPrint("→ query: ${params.toQueryParameters()}");

    return repository.filterMyProfileTests(
      queryParameters: params.toQueryParameters(),
    );
  }
}