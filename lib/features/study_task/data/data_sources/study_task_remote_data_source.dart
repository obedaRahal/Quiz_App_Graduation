import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/study_task/data/models/create_study_task_response_model.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_plan_subjects_response_model.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_task_details_model.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/update_study_task_params.dart';

abstract class StudyTaskRemoteDataSource {
  Future<StudyTaskDetailsModel> getStudyTaskDetails({
    required int planId,
    required int taskId,
  });

  Future<CreateStudyTaskResponseModel> createStudyTask({
    required CreateStudyTaskParams params,
  });

  Future<StudyPlanSubjectsResponseModel> getStudyPlanSubjects({
    required int planId,
  });

  Future<CreateStudyTaskResponseModel> updateStudyTask({
    required UpdateStudyTaskParams params,
  });
}

class StudyTaskRemoteDataSourceImpl implements StudyTaskRemoteDataSource {
  final ApiConsumer apiConsumer;

  const StudyTaskRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<StudyTaskDetailsModel> getStudyTaskDetails({
    required int planId,
    required int taskId,
  }) async {
    debugPrint(
      '============ StudyTaskRemoteDataSource.getStudyTaskDetails ============',
    );

    debugPrint('→ planId: $planId');
    debugPrint('→ taskId: $taskId');

    final endpoint = EndPoints.getStudyTaskDetails(planId, taskId);

    debugPrint('→ endpoint: $endpoint');

    try {
      final response = await apiConsumer.get(endpoint);

      debugPrint('✓ task details response received');
      debugPrint('→ response type: ${response.runtimeType}');
      debugPrint('→ response  ${response.toString()}');

      final json = _extractResponseMap(response);

      final model = StudyTaskDetailsModel.fromJson(json);

      debugPrint('→ title: ${model.title}');
      debugPrint('→ task id: ${model.data.basicInfo.id}');
      debugPrint('→ subtasks count: ${model.data.subtasks.length}');

      debugPrint(
        '=====================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyTaskRemoteDataSource.getStudyTaskDetails failed');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      debugPrint(
        '=====================================================================',
      );

      rethrow;
    }
  }

  Map<String, dynamic> _extractResponseMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }

    final dynamic data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw const FormatException('Study task response is not valid');
  }

  @override
  Future<CreateStudyTaskResponseModel> createStudyTask({
    required CreateStudyTaskParams params,
  }) async {
    debugPrint(
      '============ StudyTaskRemoteDataSource.createStudyTask ============',
    );
    debugPrint('→ planId: ${params.planId}');

    if (!params.isValid) {
      debugPrint('✗ invalid create study task params');
      debugPrint('→ params: $params');
      debugPrint(
        '==================================================================',
      );

      throw const FormatException('Invalid create study task parameters');
    }

    final endpoint = EndPoints.createStudyTask(params.planId);
    final body = params.toBody();

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ body: $body');

    try {
      final response = await apiConsumer.post(endpoint, data: body);

      debugPrint('✓ create study task response received');
      debugPrint('→ response type: ${response.runtimeType}');
      debugPrint('→ response  ${response.toString()}');

      final responseMap = _extractResponseMap(response);

      debugPrint('→ raw success: ${responseMap['success']}');
      debugPrint('→ raw title: ${responseMap['title']}');
      debugPrint('→ raw message: ${responseMap['message']}');
      debugPrint('→ raw statusCode: ${responseMap['status_code']}');

      final model = CreateStudyTaskResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '==================================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint('✗ StudyTaskRemoteDataSource.createStudyTask failure');
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
  Future<StudyPlanSubjectsResponseModel> getStudyPlanSubjects({
    required int planId,
  }) async {
    debugPrint(
      '============ '
      'StudyTaskRemoteDataSource.getStudyPlanSubjects '
      '============',
    );
    debugPrint('→ planId: $planId');

    if (planId <= 0) {
      debugPrint('✗ invalid plan id');
      debugPrint('===========================================================');

      throw const FormatException('Invalid study plan id');
    }

    final endpoint = EndPoints.getStudyPlanSubjects(planId);

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: GET');

    try {
      final response = await apiConsumer.get(endpoint);

      debugPrint('✓ study plan subjects response received');
      debugPrint('→ response type: ${response.runtimeType}');
      debugPrint('→ response  ${response.toString()}');

      final responseMap = _extractResponseMap(response);

      debugPrint('→ raw success: ${responseMap['success']}');
      debugPrint('→ raw title: ${responseMap['title']}');
      debugPrint('→ raw data: ${responseMap['data']}');
      debugPrint('→ raw statusCode: ${responseMap['status_code']}');

      final model = StudyPlanSubjectsResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ subjects count: ${model.subjects.length}');
      debugPrint('→ statusCode: ${model.statusCode}');

      for (final subject in model.subjects) {
        debugPrint('→ subject: id=${subject.id}, name=${subject.name}');
      }

      debugPrint('===========================================================');

      return model;
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskRemoteDataSource.'
        'getStudyPlanSubjects failure',
      );
      debugPrint('→ planId: $planId');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint('===========================================================');

      rethrow;
    }
  }

  @override
  Future<CreateStudyTaskResponseModel> updateStudyTask({
    required UpdateStudyTaskParams params,
  }) async {
    debugPrint(
      '============ '
      'StudyTaskRemoteDataSource.updateStudyTask '
      '============',
    );

    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ taskId: ${params.taskId}');
    debugPrint('→ params: $params');

    if (!params.isValid) {
      debugPrint('✗ invalid update study task params');
      //debugPrint('→ hasChanges: ${params.hasChanges}');
      debugPrint('→ body: ${params.toBody()}');
      debugPrint(
        '===============================================================',
      );

      throw const FormatException('Invalid update study task parameters');
    }

    final endpoint = EndPoints.updateStudyTask(params.planId, params.taskId);

    final body = params.toBody();

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: post');
    debugPrint('→ body: $body');

    try {
      final response = await apiConsumer.post(endpoint, data: body);

      debugPrint('✓ update study task response received');
      debugPrint('→ response type: ${response.runtimeType}');
      debugPrint('→ response: ${response.toString()}');

      final responseMap = _extractResponseMap(response);

      debugPrint('→ raw success: ${responseMap['success']}');
      debugPrint('→ raw title: ${responseMap['title']}');
      debugPrint('→ raw message: ${responseMap['message']}');
      debugPrint('→ raw statusCode: ${responseMap['status_code']}');

      final model = CreateStudyTaskResponseModel.fromJson(responseMap);

      debugPrint('→ success: ${model.success}');
      debugPrint('→ title: ${model.title}');
      debugPrint('→ message: ${model.message}');
      debugPrint('→ statusCode: ${model.statusCode}');
      debugPrint(
        '===============================================================',
      );

      return model;
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskRemoteDataSource.'
        'updateStudyTask failure',
      );
      debugPrint('→ planId: ${params.planId}');
      debugPrint('→ taskId: ${params.taskId}');
      debugPrint('→ body: $body');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===============================================================',
      );

      rethrow;
    }
  }
}
