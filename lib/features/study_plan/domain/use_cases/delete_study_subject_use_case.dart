import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_action_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_subject_params.dart';

class DeleteStudySubjectUseCase {
  final StudyPlanRepository repository;

  const DeleteStudySubjectUseCase(this.repository);

  Future<Either<Failure, StudySubjectActionResponseEntity>> call(
    DeleteStudySubjectParams params,
  ) {
    debugPrint("============ DeleteStudySubjectUseCase.call ============");
    debugPrint("→ params: {subjectId: ${params.subjectId}}");
    return repository.deleteStudySubject(params: params);
  }
}
