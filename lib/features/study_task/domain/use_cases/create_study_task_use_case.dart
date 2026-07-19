import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';

class CreateStudyTaskUseCase {
  final StudyTaskRepository repository;

  const CreateStudyTaskUseCase(this.repository);

  Future<Either<Failure, CreateStudyTaskResponseEntity>> call(
    CreateStudyTaskParams params,
  ) {
    debugPrint(
      '============ CreateStudyTaskUseCase.call ============',
    );
    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toBody()}');

    return repository.createStudyTask(params: params);
  }
}