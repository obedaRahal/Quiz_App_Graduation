import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';

class GetStudyTaskDetailsUseCase {
  final StudyTaskRepository repository;

  const GetStudyTaskDetailsUseCase(this.repository);

  Future<Either<Failure, StudyTaskDetailsEntity>> call(
    GetStudyTaskDetailsParams params,
  ) async {
    debugPrint('============ GetStudyTaskDetailsUseCase ============');
    debugPrint('→ params: $params');

    final result = await repository.getStudyTaskDetails(params: params);

    result.fold(
      (failure) {
        debugPrint('✗ task details use case failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');
      },
      (response) {
        debugPrint('✓ task details use case success');
        debugPrint('→ title: ${response.title}');
        debugPrint('→ taskId: ${response.data.basicInfo.id}');
        debugPrint('→ subTasks: ${response.data.subtasks.length}');
      },
    );

    debugPrint('====================================================');

    return result;
  }
}
