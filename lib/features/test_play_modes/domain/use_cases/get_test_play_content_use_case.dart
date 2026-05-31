import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/repositories/test_play_modes_repository.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/get_test_play_content_params.dart';

class GetTestPlayContentUseCase {
  final TestPlayModesRepository repository;

  const GetTestPlayContentUseCase(this.repository);

  Future<Either<Failure, TestPlayContentEntity>> call(
    GetTestPlayContentParams params,
  ) {
    debugPrint("============ GetTestPlayContentUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    final result = repository.getTestPlayContent(params);

    debugPrint("→ request forwarded to repository");
    debugPrint("=========================================================");

    return result;
  }
}
