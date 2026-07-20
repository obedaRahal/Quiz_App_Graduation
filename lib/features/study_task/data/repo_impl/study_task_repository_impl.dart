import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/data/data_sources/study_task_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/delete_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/change_study_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/delete_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/toggle_study_sub_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/update_study_task_params.dart';

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

  @override
  Future<Either<Failure, CreateStudyTaskResponseEntity>> createStudyTask({
    required CreateStudyTaskParams params,
  }) async {
    debugPrint(
      '============ StudyTaskRepositoryImpl.createStudyTask ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ body: ${params.toBody()}');

    if (!params.isValid) {
      debugPrint('✗ invalid create study task params');
      debugPrint(
        '===============================================================',
      );

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'بيانات إنشاء المهمة الدراسية غير مكتملة',
        ),
      );
    }

    try {
      final response = await remoteDataSource.createStudyTask(params: params);

      debugPrint('✓ repository created study task');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint(
        '===============================================================',
      );

      return Right(response);
    } on ServerException catch (error) {
      debugPrint('✗ StudyTaskRepositoryImpl.createStudyTask ServerException');
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint('→ status: ${error.errorModel.status}');
      debugPrint(
        '===============================================================',
      );

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } on CacheException catch (error) {
      debugPrint('✗ StudyTaskRepositoryImpl.createStudyTask CacheException');
      debugPrint('→ message: ${error.errorMessage}');
      debugPrint(
        '===============================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('✗ StudyTaskRepositoryImpl.createStudyTask unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===============================================================',
      );

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر إنشاء المهمة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, StudyPlanSubjectsResponseEntity>>
  getStudyPlanSubjects({required int planId}) async {
    debugPrint(
      '============ '
      'StudyTaskRepositoryImpl.getStudyPlanSubjects '
      '============',
    );
    debugPrint('→ planId: $planId');

    if (planId <= 0) {
      debugPrint('✗ invalid plan id');
      debugPrint('===========================================================');

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'معرّف الخطة الدراسية غير صالح',
        ),
      );
    }

    try {
      final response = await remoteDataSource.getStudyPlanSubjects(
        planId: planId,
      );

      debugPrint('✓ repository loaded study plan subjects');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ subjects count: ${response.subjects.length}');
      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint('===========================================================');

      return Right(response);
    } on ServerException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'getStudyPlanSubjects ServerException',
      );
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint('→ status: ${error.errorModel.status}');
      debugPrint('===========================================================');

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } on CacheException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'getStudyPlanSubjects CacheException',
      );
      debugPrint('→ message: ${error.errorMessage}');
      debugPrint('===========================================================');

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'getStudyPlanSubjects unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint('===========================================================');

      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب مواد الخطة الدراسية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CreateStudyTaskResponseEntity>> updateStudyTask({
    required UpdateStudyTaskParams params,
  }) async {
    debugPrint(
      '============ '
      'StudyTaskRepositoryImpl.updateStudyTask '
      '============',
    );

    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ taskId: ${params.taskId}');
    //debugPrint('→ hasChanges: ${params.hasChanges}');
    debugPrint('→ body: ${params.toBody()}');

    // if (!params.hasChanges) {
    //   debugPrint('✗ no study task changes detected');
    //   debugPrint(
    //     '===============================================================',
    //   );

    //   return const Left(
    //     ServerFailure(
    //       title: 'لا توجد تعديلات',
    //       message: 'لم يتم إجراء أي تعديل على بيانات المهمة',
    //     ),
    //   );
    // }

    if (!params.isValid) {
      debugPrint('✗ invalid update study task params');
      debugPrint(
        '===============================================================',
      );

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'بيانات تعديل المهمة الدراسية غير صالحة',
        ),
      );
    }

    try {
      final response = await remoteDataSource.updateStudyTask(params: params);

      debugPrint('✓ repository updated study task');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint(
        '===============================================================',
      );

      return Right(response);
    } on ServerException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'updateStudyTask ServerException',
      );
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint('→ status: ${error.errorModel.status}');
      debugPrint(
        '===============================================================',
      );

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } on CacheException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'updateStudyTask CacheException',
      );
      debugPrint('→ message: ${error.errorMessage}');
      debugPrint(
        '===============================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'updateStudyTask unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===============================================================',
      );

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تعديل المهمة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, DeleteStudyTaskResponseEntity>> deleteStudyTask({
    required DeleteStudyTaskParams params,
  }) async {
    debugPrint(
      '============ '
      'StudyTaskRepositoryImpl.deleteStudyTask '
      '============',
    );

    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ taskId: ${params.taskId}');

    if (!params.isValid) {
      debugPrint('✗ invalid delete study task params');
      debugPrint('=========================================================');

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'معرّف الخطة أو المهمة غير صالح',
        ),
      );
    }

    try {
      final response = await remoteDataSource.deleteStudyTask(
        planId: params.planId,
        taskId: params.taskId,
      );

      debugPrint('✓ repository deleted study task');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint('→ statusCode: ${response.statusCode}');

      debugPrint('=========================================================');

      return Right(response);
    } on ServerException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'deleteStudyTask ServerException',
      );
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint('→ status: ${error.errorModel.status}');

      debugPrint('=========================================================');

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } on CacheException catch (error) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'deleteStudyTask CacheException',
      );
      debugPrint('→ message: ${error.errorMessage}');

      debugPrint('=========================================================');

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskRepositoryImpl.'
        'deleteStudyTask unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      debugPrint('=========================================================');

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف المهمة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, CreateStudyTaskResponseEntity>> changeStudyTaskStatus({
    required ChangeStudyTaskStatusParams params,
  }) async {
    debugPrint(
      '============ StudyTaskRepositoryImpl.changeStudyTaskStatus ============',
    );
    debugPrint('→ params: $params');

    if (!params.isValid) {
      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'بيانات تغيير حالة المهمة غير صالحة',
          statusCode: 400,
        ),
      );
    }

    try {
      final response = await remoteDataSource.changeStudyTaskStatus(
        params: params,
      );

      debugPrint('→ change status response: $response');

      return Right(response);
    } on ServerException catch (exception) {
      debugPrint('→ ServerException: $exception');

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
          statusCode: exception.errorModel.status,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint('→ CacheException: $exception');

      return Left(
        CacheFailure(title: 'خطأ محلي', message: exception.errorMessage),
      );
    } catch (exception, stackTrace) {
      debugPrint('→ Unexpected exception: $exception');
      debugPrint('→ stackTrace: $stackTrace');

      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تغيير حالة المهمة، يرجى المحاولة مرة أخرى',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CreateStudyTaskResponseEntity>>
  toggleStudySubTaskStatus({
    required ToggleStudySubTaskStatusParams params,
  }) async {
    debugPrint(
      '============ '
      'StudyTaskRepositoryImpl.toggleStudySubTaskStatus '
      '============',
    );

    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.toggleStudySubTaskStatus(
        params: params,
      );

      debugPrint('✓ toggle study subtask status repository success');

      return Right(response);
    } on ServerException catch (exception) {
      debugPrint('→ ServerException: $exception');

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
          statusCode: exception.errorModel.status,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint('→ CacheException: $exception');

      return Left(
        CacheFailure(title: 'خطأ محلي', message: exception.errorMessage),
      );
    } catch (exception, stackTrace) {
      debugPrint('→ Unexpected exception: $exception');
      debugPrint('→ stackTrace: $stackTrace');

      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تغيير حالة المهمة، يرجى المحاولة مرة أخرى',
          statusCode: 500,
        ),
      );
    }
  }
}
