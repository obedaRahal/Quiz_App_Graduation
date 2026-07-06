import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_bookmarks_params.dart';

class FetchMyProfileBookmarksUseCase {
  final MyProfileRepository repository;

  const FetchMyProfileBookmarksUseCase(this.repository);

  Future<Either<Failure, MyProfileBookmarksEntity>> call(
    FetchMyProfileBookmarksParams params,
  ) {
    debugPrint("============ FetchMyProfileBookmarksUseCase.call ============");
    debugPrint("→ tab: ${params.tab}");
    debugPrint("→ cursor: ${params.cursor}");

    return repository.fetchMyProfileBookmarks(
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}