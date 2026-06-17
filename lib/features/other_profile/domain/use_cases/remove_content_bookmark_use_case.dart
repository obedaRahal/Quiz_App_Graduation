import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/content_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/content_bookmark_action_params.dart';

class RemoveContentBookmarkUseCase {
  final OtherProfileRepository repository;

  const RemoveContentBookmarkUseCase(this.repository);

  Future<Either<Failure, ContentBookmarkActionEntity>> call(
    ContentBookmarkActionParams params,
  ) {
    debugPrint("============ RemoveContentBookmarkUseCase.call ============");
    debugPrint("→ params: {contentId: ${params.contentId}}");

    return repository.removeContentBookmark(contentId: params.contentId);
  }
}