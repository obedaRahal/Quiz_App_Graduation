import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';

class GetStudySubjectsUseCase {
  final StudyPlanRepository repository;

  const GetStudySubjectsUseCase(this.repository);

  Future<Either<Failure, StudySubjectsResponseEntity>> call() {
    debugPrint("============ GetStudySubjectsUseCase.call ============");
    return repository.getStudySubjects();
  }
}
