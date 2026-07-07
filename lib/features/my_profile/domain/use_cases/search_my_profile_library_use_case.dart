import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/search_my_profile_library_params.dart';

class SearchMyProfileLibraryUseCase {
  final MyProfileRepository repository;

  const SearchMyProfileLibraryUseCase(this.repository);

  Future<Either<Failure, MyProfileLibraryEntity>> call(
    SearchMyProfileLibraryParams params,
  ) {
    debugPrint("============ SearchMyProfileLibraryUseCase.call ============");
    debugPrint("→ query: ${params.query}");
    debugPrint("→ mode: ${params.mode}");
    debugPrint("→ cursor: ${params.cursor}");

    return repository.searchMyProfileLibrary(
      query: params.query,
      mode: params.mode,
      cursor: params.cursor,
    );
  }
}