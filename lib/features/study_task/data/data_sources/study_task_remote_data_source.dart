import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_task_details_model.dart';

abstract class StudyTaskRemoteDataSource {
  Future<StudyTaskDetailsModel> getStudyTaskDetails({
    required int planId,
    required int taskId,
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
}
