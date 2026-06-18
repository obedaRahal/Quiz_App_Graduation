import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_receive_entitiy.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_receive_params.dart';

class GetOtherProfileReceiveUseCase {
  final OtherProfileRepository repository;

  const GetOtherProfileReceiveUseCase(this.repository);

  Future<Either<Failure, OtherProfileReceiveEntity>> call(
    GetOtherProfileReceiveParams params,
  ) {
    debugPrint("============ GetOtherProfileReceiveUseCase.call ============");
    debugPrint("→ params: {slug: ${params.slug}}");

    return repository.getOtherProfileReceive(slug: params.slug);
  }
}
