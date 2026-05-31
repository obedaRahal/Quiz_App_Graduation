import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/data_sources/test_play_modes_remote_data_source.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/repositories/test_play_modes_repository.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/get_test_play_content_params.dart';

class TestPlayModesRepositoryImpl implements TestPlayModesRepository {
  final TestPlayModesRemoteDataSource remoteDataSource;

  const TestPlayModesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, TestPlayContentEntity>> getTestPlayContent(
    GetTestPlayContentParams params,
  ) async {
    debugPrint(
      "============ TestPlayModesRepositoryImpl.getTestPlayContent ============",
    );

    debugPrint(
      "→ params: {testId: ${params.testId}}",
    );

    try {
      debugPrint(
        "→ calling remoteDataSource.getTestPlayContent",
      );

      final model = await remoteDataSource.getTestPlayContent(
        params,
      );

      debugPrint(
        "← remoteDataSource.getTestPlayContent success",
      );

      debugPrint(
        "→ test title: ${model.data.test.title}",
      );

      debugPrint(
        "→ questions count: ${model.data.test.questions.length}",
      );

      debugPrint(
        "=================================================",
      );

      return Right(
        model.toEntity(),
      );
    } on ServerException catch (e) {
      debugPrint(
        "✗ TestPlayModesRepositoryImpl.getTestPlayContent ServerException: ${e.errorModel.errorMessage}",
      );

      debugPrint(
        "=================================================",
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ TestPlayModesRepositoryImpl.getTestPlayContent CacheException: ${e.errorMessage}",
      );

      debugPrint(
        "=================================================",
      );

      return Left(
        CacheFailure(
          title: 'خطأ محلي',
          message: e.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint(
        "✗ TestPlayModesRepositoryImpl.getTestPlayContent Unexpected error: $e",
      );

      debugPrint(
        "=================================================",
      );

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع',
        ),
      );
    }
  }
}