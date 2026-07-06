import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_picture_params.dart';

class EditMyProfilePictureUseCase {
  final MyProfileRepository repository;

  const EditMyProfilePictureUseCase(this.repository);

  Future<Either<Failure, EditMyProfilePictureEntity>> call(
    EditMyProfilePictureParams params,
  ) {
    debugPrint("============ EditMyProfilePictureUseCase.call ============");
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ type: ${params.type}");
    debugPrint("→ imagePath: ${params.imagePath}");

    return repository.editMyProfilePicture(
      userId: params.userId,
      type: params.type,
      imagePath: params.imagePath,
    );
  }
}