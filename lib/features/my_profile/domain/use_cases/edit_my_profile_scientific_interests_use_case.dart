import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_scientific_interests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_scientific_interests_params.dart';

class EditMyProfileScientificInterestsUseCase {
  final MyProfileRepository repository;

  const EditMyProfileScientificInterestsUseCase(this.repository);

  Future<Either<Failure, EditMyProfileScientificInterestsEntity>> call(
    EditMyProfileScientificInterestsParams params,
  ) {
    debugPrint(
      "============ EditMyProfileScientificInterestsUseCase.call ============",
    );
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ interestIds: ${params.interestIds}");

    return repository.editMyProfileScientificInterests(
      userId: params.userId,
      interestIds: params.interestIds,
    );
  }
}