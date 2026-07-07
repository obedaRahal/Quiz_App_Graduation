import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_library_params.dart';

class FetchMyProfileLibraryUseCase {
  final MyProfileRepository repository;

  const FetchMyProfileLibraryUseCase(this.repository);

  Future<Either<Failure, MyProfileLibraryEntity>> call(
    FetchMyProfileLibraryParams params,
  ) {
    debugPrint("============ FetchMyProfileLibraryUseCase.call ============");
    debugPrint("→ userId: ${params.userId}");
    debugPrint("→ tab: ${params.tab}");
    debugPrint("→ cursor: ${params.cursor}");

    return repository.fetchMyProfileLibrary(
      userId: params.userId,
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}