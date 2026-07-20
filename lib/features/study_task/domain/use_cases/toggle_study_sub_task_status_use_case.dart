import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/toggle_study_sub_task_status_params.dart';

class ToggleStudySubTaskStatusUseCase {
  final StudyTaskRepository repository;

  const ToggleStudySubTaskStatusUseCase(this.repository);

  Future<Either<Failure, CreateStudyTaskResponseEntity>> call(
    ToggleStudySubTaskStatusParams params,
  ) {
    debugPrint(
      '============ ToggleStudySubTaskStatusUseCase.call ============',
    );

    debugPrint('→ params: $params');

    return repository.toggleStudySubTaskStatus(params: params);
  }
}
