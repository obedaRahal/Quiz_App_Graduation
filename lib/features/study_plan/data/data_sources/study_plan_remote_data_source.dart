import 'package:flutter/cupertino.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/create_study_plan_response_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/delete_study_plan_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_overview_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_tasks_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_overview_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plans_response_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_subject_action_response_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_subjects_response_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/update_study_plan_params.dart';

abstract class StudyPlanRemoteDataSource {
  Future<StudyPlanOverviewModel> getDailyTasksOverview({
    required GetStudyPlanDailyOverviewParams params,
  });

  Future<StudySubjectsResponseModel> getStudySubjects();

  Future<StudySubjectActionResponseModel> createStudySubject({
    required CreateStudySubjectParams params,
  });

  Future<StudySubjectActionResponseModel> deleteStudySubject({
    required DeleteStudySubjectParams params,
  });

  Future<CreateStudyPlanResponseModel> createStudyPlan({
    required CreateStudyPlanParams params,
  });

  Future<StudyPlansResponseModel> getStudyPlans({
    required GetStudyPlansParams params,
  });

  Future<StudyPlanDetailsOverviewModel> getStudyPlanDetailsOverview({
    required int planId,
  });

  Future<StudyPlanDetailsTasksModel> getStudyPlanDetailsTasks({
    required int planId,
  });

  Future<CreateStudyPlanResponseModel> updateStudyPlan({
    required UpdateStudyPlanParams params,
  });

  Future<DeleteStudyPlanModel> deleteStudyPlan({required int planId});
}

class StudyPlanRemoteDataSourceImpl implements StudyPlanRemoteDataSource {
  final ApiConsumer apiConsumer;

  const StudyPlanRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<StudyPlanOverviewModel> getDailyTasksOverview({
    required GetStudyPlanDailyOverviewParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.getDailyTasksOverview ============',
    );
    debugPrint('→ endpoint: ${EndPoints.getStudyPlanDailyOverview}');
    debugPrint('→ queryParameters: ${params.toQueryParameters()}');

    try {
      final response = await apiConsumer.get(
        EndPoints.getStudyPlanDailyOverview,
        queryParameters: params.toQueryParameters(),
      );

      debugPrint('✓ study plan overview response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      debugPrint('→ success: ${responseMap['success']}');
      debugPrint('→ status_code: ${responseMap['status_code']}');

      final model = StudyPlanOverviewModel.fromJson(responseMap);

      debugPrint('→ hasDefaultPlan: ${model.data.hasDefaultPlan}');
      debugPrint('→ selectedDate: ${model.data.selectedDate}');
      debugPrint(
        '→ range: ${model.data.range.start} → ${model.data.range.end}',
      );
      debugPrint('→ days count: ${model.data.days.length}');
      debugPrint('→ tasks count: ${model.data.tasks.length}');
      debugPrint(
        '===============================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ getDailyTasksOverview remote failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===============================================================',
      );

      rethrow;
    }
  }

  Map<String, dynamic> _extractResponseMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }

    // إن كان ApiConsumer يعيد Dio Response.
    final dynamic data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw const FormatException(
      'Study plan overview response is not a valid JSON object',
    );
  }

  @override
  Future<StudySubjectsResponseModel> getStudySubjects() async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.getStudySubjects ============',
    );
    debugPrint('→ endpoint: ${EndPoints.getStudySubjects}');

    try {
      final response = await apiConsumer.get(EndPoints.getStudySubjects);

      debugPrint('✓ study subjects response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      final model = StudySubjectsResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint('→ subjects count: ${model.subjects.length}');
      debugPrint(
        '=================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRemoteDataSource.getStudySubjects failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '=================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<StudySubjectActionResponseModel> createStudySubject({
    required CreateStudySubjectParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.createStudySubject ============',
    );
    debugPrint('→ endpoint: ${EndPoints.createStudySubject}');
    debugPrint('→ body: ${params.toBody()}');

    try {
      final response = await apiConsumer.post(
        EndPoints.createStudySubject,
        data: params.toBody(),
      );

      debugPrint('✓ create study subject response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      final model = StudySubjectActionResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '=====================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRemoteDataSource.createStudySubject failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '=====================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<StudySubjectActionResponseModel> deleteStudySubject({
    required DeleteStudySubjectParams params,
  }) async {
    final endpoint = EndPoints.deleteStudySubject(params.subjectId);

    debugPrint(
      '============ StudyPlanRemoteDataSource.deleteStudySubject ============',
    );
    debugPrint('→ subjectId: ${params.subjectId}');
    debugPrint('→ endpoint: $endpoint');

    try {
      final response = await apiConsumer.delete(endpoint);

      debugPrint('✓ delete study subject response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      final model = StudySubjectActionResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '=====================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRemoteDataSource.deleteStudySubject failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '=====================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<CreateStudyPlanResponseModel> createStudyPlan({
    required CreateStudyPlanParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.createStudyPlan ============',
    );
    debugPrint('→ endpoint: ${EndPoints.createStudyPlan}');
    debugPrint('→ body: ${params.toBody()}');

    try {
      final response = await apiConsumer.post(
        EndPoints.createStudyPlan,
        data: params.toBody(),
      );

      debugPrint('√ create study plan response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      final model = CreateStudyPlanResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '==================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('X StudyPlanRemoteDataSource.createStudyPlan failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '==================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<StudyPlansResponseModel> getStudyPlans({
    required GetStudyPlansParams params,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.getStudyPlans ============',
    );
    debugPrint('→ endpoint: ${EndPoints.getStudyPlans}');
    debugPrint('→ queryParameters: ${params.toQueryParameters()}');

    try {
      final response = await apiConsumer.get(
        EndPoints.getStudyPlans,
        queryParameters: params.toQueryParameters(),
      );

      debugPrint('√ study plans response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      final model = StudyPlansResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint('→ plansCount: ${model.plansCount}');
      debugPrint('→ plans length: ${model.plans.length}');

      for (final plan in model.plans) {
        debugPrint(
          '→ plan: '
          'id=${plan.id}, '
          'title=${plan.title}, '
          'isDefault=${plan.isDefault}, '
          'hours=${plan.dailyStudyHours}, '
          'remainingDays=${plan.remainingDays}',
        );
      }

      debugPrint(
        '================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('X StudyPlanRemoteDataSource.getStudyPlans failure');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<StudyPlanDetailsOverviewModel> getStudyPlanDetailsOverview({
    required int planId,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.getStudyPlanDetailsOverview ============',
    );
    debugPrint('→ planId: $planId');

    final endpoint = EndPoints.getStudyPlanDetailsOverview(planId);

    debugPrint('→ endpoint: $endpoint');

    try {
      final response = await apiConsumer.get(endpoint);

      debugPrint('✓ Study plan details overview response received');
      debugPrint('→ response: $response');

      final Map<String, dynamic> json = response is Map<String, dynamic>
          ? response
          : Map<String, dynamic>.from(response as Map);

      final model = StudyPlanDetailsOverviewModel.fromJson(json);

      debugPrint('→ plan id: ${model.id}');
      debugPrint('→ plan title: ${model.planTitle}');
      debugPrint('→ subjects count: ${model.subjects.count}');
      debugPrint('→ subjects label: ${model.subjects.label}');
      debugPrint('→ remaining days: ${model.progress.remainingDays}');
      debugPrint(
        '→ completed percentage: ${model.progress.completedPercentage}',
      );
      debugPrint(
        '==============================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyPlanRemoteDataSource.getStudyPlanDetailsOverview failed',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '==============================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<StudyPlanDetailsTasksModel> getStudyPlanDetailsTasks({
    required int planId,
  }) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.getStudyPlanDetailsTasks ============',
    );
    debugPrint('→ planId: $planId');

    if (planId <= 0) {
      debugPrint('✗ invalid planId: $planId');
      debugPrint(
        '============================================================================',
      );

      throw const FormatException('Invalid study plan id');
    }

    final endpoint = EndPoints.getStudyPlanDetailsTasks(planId);

    debugPrint('→ endpoint: $endpoint');

    try {
      final response = await apiConsumer.get(endpoint);

      debugPrint('✓ tasks response received');
      debugPrint('→ response runtimeType: ${response.runtimeType}');

      final json = response is Map<String, dynamic>
          ? response
          : Map<String, dynamic>.from(response as Map);

      final model = StudyPlanDetailsTasksModel.fromJson(json);

      debugPrint('→ title: ${model.title}');
      debugPrint('→ old count: ${model.old.count}');
      debugPrint('→ upcoming count: ${model.upcoming.count}');
      debugPrint('→ completed count: ${model.completed.count}');
      debugPrint('→ total count: ${model.totalCount}');
      debugPrint(
        '============================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRemoteDataSource.getStudyPlanDetailsTasks error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '============================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<CreateStudyPlanResponseModel> updateStudyPlan({
    required UpdateStudyPlanParams params,
  }) async {
    final endpoint = EndPoints.updateStudyPlan(params.planId);
    final body = params.toBody();

    debugPrint(
      '============ StudyPlanRemoteDataSource.updateStudyPlan ============',
    );
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ body: $body');

    if (!params.isValid) {
      debugPrint('✗ invalid update study plan params');
      debugPrint(
        '==================================================================',
      );

      throw const FormatException('Invalid update study plan parameters');
    }

    try {
      final response = await apiConsumer.post(endpoint, data: body);

      debugPrint('✓ update study plan response received');
      debugPrint('→ response type: ${response.runtimeType}');

      final responseMap = _extractResponseMap(response);

      debugPrint('→ raw success: ${responseMap['success']}');
      debugPrint('→ raw title: ${responseMap['title']}');
      debugPrint('→ raw message: ${responseMap['message']}');
      debugPrint('→ raw statusCode: ${responseMap['status_code']}');

      final model = CreateStudyPlanResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '==================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanRemoteDataSource.updateStudyPlan failure');
      debugPrint('→ planId: ${params.planId}');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '==================================================================',
      );

      rethrow;
    }
  }

  @override
  Future<DeleteStudyPlanModel> deleteStudyPlan({required int planId}) async {
    debugPrint(
      '============ StudyPlanRemoteDataSource.deleteStudyPlan ============',
    );
    debugPrint('→ planId: $planId');

    final endpoint = EndPoints.deleteStudyPlan(planId);

    debugPrint('→ method: DELETE');
    debugPrint('→ endpoint: $endpoint');

    final response = await apiConsumer.delete(endpoint);

    debugPrint('→ raw response: $response');

    final json = _extractResponseMap(response);

    final model = DeleteStudyPlanModel.fromJson(json);

    debugPrint('→ result: $model');
    debugPrint(
      '===================================================================',
    );

    return model;
  }
}
