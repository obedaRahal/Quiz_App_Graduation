import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/test_bookmark_action_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/test_bookmark_action_params.dart';

class BookmarkTestUseCase {
  final DetailsOfTestRepository repository;

  const BookmarkTestUseCase(this.repository);

  Future<Either<Failure, TestBookmarkActionEntity>> call(
    TestBookmarkActionParams params,
  ) {
    debugPrint("============ BookmarkTestUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.bookmarkTest(testId: params.testId);
  }
}