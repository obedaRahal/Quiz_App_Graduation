import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/delete_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/delete_my_profile_picture_params.dart';

class DeleteMyProfilePictureUseCase {
  final MyProfileRepository repository;

  const DeleteMyProfilePictureUseCase(this.repository);

  Future<Either<Failure, DeleteMyProfilePictureEntity>> call(
    DeleteMyProfilePictureParams params,
  ) {
    debugPrint("============ DeleteMyProfilePictureUseCase.call ============");
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ type: ${params.type}");

    return repository.deleteMyProfilePicture(
      userId: params.userId,
      type: params.type,
    );
  }
}