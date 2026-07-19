import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';

class GetStudyPlanSubjectsUseCase {
  final StudyTaskRepository repository;

  const GetStudyPlanSubjectsUseCase(this.repository);

  Future<Either<Failure, StudyPlanSubjectsResponseEntity>> call({
    required int planId,
  }) {
    debugPrint('============ GetStudyPlanSubjectsUseCase.call ============');
    debugPrint('→ planId: $planId');

    return repository.getStudyPlanSubjects(planId: planId);
  }
}
