import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_share_link_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_share_link_params.dart';

class GetOtherProfileShareLinkUseCase {
  final OtherProfileRepository repository;

  const GetOtherProfileShareLinkUseCase(this.repository);

  Future<Either<Failure, OtherProfileShareLinkEntity>> call(
    GetOtherProfileShareLinkParams params,
  ) {
    debugPrint(
      "============ GetOtherProfileShareLinkUseCase.call ============",
    );
    debugPrint("→ params: {userId: ${params.userId}}");

    return repository.getOtherProfileShareLink(userId: params.userId);
  }
}
