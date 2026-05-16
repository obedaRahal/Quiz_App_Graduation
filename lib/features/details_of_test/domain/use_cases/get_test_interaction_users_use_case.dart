import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/test_interaction_users_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/get_test_interaction_users_params.dart';

class GetTestInteractionUsersUseCase {
  final DetailsOfTestRepository repository;

  const GetTestInteractionUsersUseCase(this.repository);

  Future<Either<Failure, TestInteractionUsersEntity>> call(
    GetTestInteractionUsersParams params,
  ) {
    debugPrint("============ GetTestInteractionUsersUseCase.call ============");
    debugPrint(
      "→ params: {testId: ${params.testId}, type: ${params.type}, search: ${params.search}, cursor: ${params.cursor}}",
    );

    return repository.getTestInteractionUsers(
      testId: params.testId,
      type: params.type,
      search: params.search ?? '',
      cursor: params.cursor,
    );
  }
}