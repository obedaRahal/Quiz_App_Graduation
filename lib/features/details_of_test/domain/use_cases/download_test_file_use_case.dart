import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/download_test_file_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/download_test_file_params.dart';

class DownloadTestFileUseCase {
  final DetailsOfTestRepository repository;

  const DownloadTestFileUseCase(this.repository);

  Future<Either<Failure, DownloadTestFileEntity>> call(
    DownloadTestFileParams params,
  ) {
    debugPrint("============ DownloadTestFileUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.downloadTestFile(
      testId: params.testId,
    );
  }
}