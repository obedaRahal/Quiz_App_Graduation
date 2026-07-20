import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/delete_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/delete_study_task_params.dart';

class DeleteStudyTaskUseCase {
  final StudyTaskRepository repository;

  const DeleteStudyTaskUseCase(this.repository);

  Future<Either<Failure, DeleteStudyTaskResponseEntity>> call(
    DeleteStudyTaskParams params,
  ) {
    debugPrint('============ CreateStudyTaskUseCase.call ============');
    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toString()}');

    return repository.deleteStudyTask(params: params);
  }
}
