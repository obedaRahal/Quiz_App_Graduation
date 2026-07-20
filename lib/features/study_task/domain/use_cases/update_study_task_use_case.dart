import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/update_study_task_params.dart';

class UpdateStudyTaskUseCase {
  final StudyTaskRepository repository;

  const UpdateStudyTaskUseCase(this.repository);

  Future<Either<Failure, CreateStudyTaskResponseEntity>> call(
    UpdateStudyTaskParams params,
  ) {
    debugPrint(
      '============ '
      'UpdateStudyTaskUseCase.call '
      '============',
    );
    debugPrint('→ params: $params');
    //debugPrint('→ hasChanges: ${params.hasChanges}');
    debugPrint('→ body: ${params.toBody()}');

    return repository.updateStudyTask(params: params);
  }
}
