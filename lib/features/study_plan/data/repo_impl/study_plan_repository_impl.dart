import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/data/data_sources/study_plan_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/create_update/create_study_plan_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/delete_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_tasks_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plans_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_action_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_tasks_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/update_study_plan_params.dart';

class StudyPlanRepositoryImpl implements StudyPlanRepository {
  final StudyPlanRemoteDataSource remoteDataSource;

  const StudyPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudyPlanOverviewEntity>> getDailyTasksOverview({
    required GetStudyPlanDailyOverviewParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.getDailyTasksOverview ============',
    );
    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.getDailyTasksOverview(
        params: params,
      );

      debugPrint('✓ repository received study plan overview');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ has plan: ${response.data.hasPlan}');
      debugPrint('→ tasks count: ${response.data.tasks.length}');
      debugPrint(
        '====================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getDailyTasksOverview ServerException',
      );
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '====================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getDailyTasksOverview CacheException',
      );
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '====================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getDailyTasksOverview Unexpected error',
      );
      debugPrint('→ error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '====================================================================',
      );

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب بيانات الخطة الدراسية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, StudySubjectsResponseEntity>>
  getStudySubjects() async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.getStudySubjects ============',
    );

    try {
      final response = await remoteDataSource.getStudySubjects();

      debugPrint('✓ repository received study subjects');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ subjects count: ${response.subjects.length}');
      debugPrint(
        '================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('✗ StudyPlanRepositoryImpl.getStudySubjects ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ StudyPlanRepositoryImpl.getStudySubjects CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ StudyPlanRepositoryImpl.getStudySubjects Unexpected error');
      debugPrint('→ error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب المواد الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, StudySubjectActionResponseEntity>> createStudySubject({
    required CreateStudySubjectParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.createStudySubject ============',
    );
    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.createStudySubject(
        params: params,
      );

      debugPrint('✓ repository created study subject');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint(
        '===================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.createStudySubject ServerException',
      );
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '===================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ StudyPlanRepositoryImpl.createStudySubject CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '===================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.createStudySubject Unexpected error',
      );
      debugPrint('→ error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر إنشاء المادة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, StudySubjectActionResponseEntity>> deleteStudySubject({
    required DeleteStudySubjectParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.deleteStudySubject ============',
    );
    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.deleteStudySubject(
        params: params,
      );

      debugPrint('✓ repository deleted study subject');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint(
        '===================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.deleteStudySubject ServerException',
      );
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '===================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ StudyPlanRepositoryImpl.deleteStudySubject CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '===================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.deleteStudySubject Unexpected error',
      );
      debugPrint('→ error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف المادة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, CreateStudyPlanResponseEntity>> createStudyPlan({
    required CreateStudyPlanParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.createStudyPlan ============',
    );
    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.createStudyPlan(params: params);

      debugPrint('√ repository created study plan');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint(
        '================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('X StudyPlanRepositoryImpl.createStudyPlan ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('X StudyPlanRepositoryImpl.createStudyPlan CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('X StudyPlanRepositoryImpl.createStudyPlan unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر إنشاء الخطة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, StudyPlansResponseEntity>> getStudyPlans({
    required GetStudyPlansParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.getStudyPlans ============',
    );
    debugPrint('→ params: $params');

    try {
      final response = await remoteDataSource.getStudyPlans(params: params);

      debugPrint('√ repository received study plans');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ plansCount: ${response.plansCount}');
      debugPrint('→ plans length: ${response.plans.length}');
      debugPrint(
        '================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('X StudyPlanRepositoryImpl.getStudyPlans ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('X StudyPlanRepositoryImpl.getStudyPlans CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('X StudyPlanRepositoryImpl.getStudyPlans unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب الخطط الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, StudyPlanDetailsOverviewEntity>>
  getStudyPlanDetailsOverview({
    required GetStudyPlanDetailsOverviewParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.getStudyPlanDetailsOverview ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');

    if (!params.isValid) {
      debugPrint('✗ invalid study plan id: ${params.planId}');
      debugPrint(
        '============================================================================',
      );

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'معرّف الخطة الدراسية غير صالح',
        ),
      );
    }

    try {
      final response = await remoteDataSource.getStudyPlanDetailsOverview(
        planId: params.planId,
      );

      debugPrint('✓ repository received study plan details overview');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ response title: ${response.title}');
      debugPrint('→ planId: ${response.id}');
      debugPrint('→ planTitle: ${response.planTitle}');
      debugPrint('→ subjectsCount: ${response.subjects.count}');
      debugPrint('→ subjectsLabel: ${response.subjects.label}');
      debugPrint('→ remainingDays: ${response.progress.remainingDays}');
      debugPrint(
        '→ completedPercentage: '
        '${response.progress.completedPercentage}',
      );
      debugPrint(
        '============================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getStudyPlanDetailsOverview '
        'ServerException',
      );
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '============================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getStudyPlanDetailsOverview '
        'CacheException',
      );
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '============================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyPlanRepositoryImpl.getStudyPlanDetailsOverview '
        'unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '============================================================================',
      );

      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب تفاصيل الخطة الدراسية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, StudyPlanDetailsTasksEntity>>
  getStudyPlanDetailsTasks({
    required GetStudyPlanDetailsTasksParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.getStudyPlanDetailsTasks ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');

    if (params.planId <= 0) {
      debugPrint('✗ invalid planId');
      debugPrint(
        '===========================================================================',
      );

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'معرّف الخطة الدراسية غير صالح',
        ),
      );
    }

    try {
      final response = await remoteDataSource.getStudyPlanDetailsTasks(
        planId: params.planId,
      );

      debugPrint('✓ tasks received from remote');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ old count: ${response.old.count}');
      debugPrint('→ upcoming count: ${response.upcoming.count}');
      debugPrint('→ completed count: ${response.completed.count}');
      debugPrint(
        '===========================================================================',
      );

      return Right(response);
    } on ServerException catch (error) {
      debugPrint('✗ getStudyPlanDetailsTasks ServerException');
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint(
        '===========================================================================',
      );

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (error) {
      debugPrint('✗ getStudyPlanDetailsTasks CacheException');
      debugPrint('→ message: ${error.errorMessage}');
      debugPrint(
        '===========================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('✗ getStudyPlanDetailsTasks Unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===========================================================================',
      );

      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب مهام الخطة الدراسية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CreateStudyPlanResponseEntity>> updateStudyPlan({
    required UpdateStudyPlanParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.updateStudyPlan ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ body: ${params.toBody()}');

    if (!params.isValid) {
      debugPrint('✗ invalid update study plan params');
      debugPrint(
        '================================================================',
      );

      return const Left(
        ServerFailure(
          title: 'بيانات غير صالحة',
          message: 'بيانات تعديل الخطة الدراسية غير مكتملة',
        ),
      );
    }

    try {
      final response = await remoteDataSource.updateStudyPlan(params: params);

      debugPrint('✓ repository updated study plan');
      debugPrint('→ success: ${response.success}');
      debugPrint('→ title: ${response.title}');
      debugPrint('→ message: ${response.message}');
      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint(
        '================================================================',
      );

      return Right(response);
    } on ServerException catch (error) {
      debugPrint('✗ StudyPlanRepositoryImpl.updateStudyPlan ServerException');
      debugPrint('→ title: ${error.errorModel.errorTitle}');
      debugPrint('→ message: ${error.errorModel.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (error) {
      debugPrint('✗ StudyPlanRepositoryImpl.updateStudyPlan CacheException');
      debugPrint('→ message: ${error.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: error.errorMessage));
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRepositoryImpl.updateStudyPlan unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تعديل الخطة الدراسية'),
      );
    }
  }

  @override
  Future<Either<Failure, DeleteStudyPlanEntity>> deleteStudyPlan(
    DeleteStudyPlanParams params,
  ) async {
    debugPrint(
      '============ StudyPlanRepositoryImpl.deleteStudyPlan ============',
    );
    debugPrint('→ params: $params');

    try {
      final result = await remoteDataSource.deleteStudyPlan(
        planId: params.planId,
      );

      debugPrint('✓ repository delete success');
      debugPrint('→ result: $result');
      debugPrint(
        '================================================================',
      );

      return Right(result);
    } on ServerException catch (exception) {
      debugPrint('✗ repository ServerException');
      debugPrint('→ exception: $exception');

      final failure = ServerFailure(
        message: exception.errorModel.errorMessage,
        title: exception.errorModel.errorTitle,
        statusCode: exception.errorModel.status,
      );

      return Left(failure);
    } catch (error, stackTrace) {
      debugPrint('✗ repository unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف الخطة الدراسية'),
      );
    }
  }
}
