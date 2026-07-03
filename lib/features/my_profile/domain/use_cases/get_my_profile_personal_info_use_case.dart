import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/get_my_profile_personal_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';

class GetMyProfilePersonalInfoUseCase {
  final MyProfileRepository repository;

  const GetMyProfilePersonalInfoUseCase(this.repository);

  Future<Either<Failure, MyProfileEntity>> call(
    GetMyProfilePersonalInfoParams params,
  ) {
    debugPrint(
      "============ GetMyProfilePersonalInfoUseCase.call ============",
    );
    debugPrint("→ params: {userId: ${params.userId}}");

    return repository.getMyProfilePersonalInfo(userId: params.userId);
  }
}
