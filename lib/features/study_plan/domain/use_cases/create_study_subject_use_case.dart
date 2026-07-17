import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_action_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_subject_params.dart';

class CreateStudySubjectUseCase {
  final StudyPlanRepository repository;

  const CreateStudySubjectUseCase(this.repository);

  Future<Either<Failure, StudySubjectActionResponseEntity>> call(
    CreateStudySubjectParams params,
  ) {
    debugPrint("============ CreateStudySubjectUseCase.call ============");
    debugPrint("→ params: {name: ${params.name}}");
    return repository.createStudySubject(params: params);
  }
}
