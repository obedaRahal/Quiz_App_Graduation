import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/get_test_play_content_params.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

abstract class TestPlayModesRepository {
  Future<Either<Failure, TestPlayContentEntity>> getTestPlayContent(
    GetTestPlayContentParams params,
  );
}