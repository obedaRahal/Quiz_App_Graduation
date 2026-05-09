import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/test_follow_action_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/test_follow_action_params.dart';

class FollowCreatorUseCase {
  final DetailsOfTestRepository repository;

  const FollowCreatorUseCase(this.repository);

  Future<Either<Failure, TestFollowActionEntity>> call(
    TestFollowActionParams params,
  ) {
    debugPrint("============ FollowCreatorUseCase.call ============");
    debugPrint("→ params: {creatorId: ${params.creatorId}}");

    return repository.followCreator(
      creatorId: params.creatorId,
    );
  }
}