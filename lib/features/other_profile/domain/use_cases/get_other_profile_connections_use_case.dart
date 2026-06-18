import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_connections_params.dart';

class GetOtherProfileConnectionsUseCase {
  final OtherProfileRepository repository;

  const GetOtherProfileConnectionsUseCase(this.repository);

  Future<Either<Failure, OtherProfileConnectionsResponseEntity>> call(
    GetOtherProfileConnectionsParams params,
  ) {
    debugPrint(
      "============ GetOtherProfileConnectionsUseCase.call ============",
    );
    debugPrint(
      "→ params: {userId: ${params.userId}, type: ${params.type}, search: ${params.search}, cursor: ${params.cursor}}",
    );

    return repository.getOtherProfileConnections(
      userId: params.userId,
      type: params.type,
      search: params.search,
      cursor: params.cursor,
    );
  }
}
