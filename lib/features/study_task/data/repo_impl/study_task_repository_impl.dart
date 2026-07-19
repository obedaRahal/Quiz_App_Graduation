import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/data/data_sources/study_task_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';

class StudyTaskRepositoryImpl implements StudyTaskRepository {
  final StudyTaskRemoteDataSource remoteDataSource;

  const StudyTaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudyTaskDetailsEntity>> getStudyTaskDetails({
    required GetStudyTaskDetailsParams params,
  }) async {
    debugPrint(
      '============ StudyTaskRepositoryImpl.getStudyTaskDetails ============',
    );

    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ taskId: ${params.taskId}');

    try {
      final response = await remoteDataSource.getStudyTaskDetails(
        planId: params.planId,
        taskId: params.taskId,
      );

      debugPrint('✓ repository received task details');
      debugPrint('→ task id: ${response.data.basicInfo.id}');
      debugPrint('→ task title: ${response.data.basicInfo.title}');

      debugPrint(
        '====================================================================',
      );

      return Right(response);
    } on ServerException catch (error) {
      debugPrint('✗ getStudyTaskDetails ServerException');

      debugPrint('→ title: ${error.errorModel.errorTitle}');

      debugPrint('→ message: ${error.errorModel.errorMessage}');

      debugPrint(
        '====================================================================',
      );

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (error) {
      debugPrint('✗ getStudyTaskDetails CacheException');

      debugPrint('→ message: ${error.errorMessage}');

      debugPrint(
        '====================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('✗ getStudyTaskDetails Unexpected error');

      debugPrint('→ error: $error');

      debugPrint('→ stackTrace: $stackTrace');

      debugPrint(
        '====================================================================',
      );

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب تفاصيل المهمة'),
      );
    }
  }
}
