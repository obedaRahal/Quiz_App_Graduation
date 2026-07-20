import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/change_study_task_status_params.dart';

class ChangeStudyTaskStatusUseCase {
  final StudyTaskRepository repository;

  const ChangeStudyTaskStatusUseCase(this.repository);

  Future<Either<Failure, CreateStudyTaskResponseEntity>> call(
    ChangeStudyTaskStatusParams params,
  ) {
    debugPrint(
      '============ ChangeStudyTaskStatusUseCase.call ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toString()}');

    return repository.changeStudyTaskStatus(params: params);
  }
}