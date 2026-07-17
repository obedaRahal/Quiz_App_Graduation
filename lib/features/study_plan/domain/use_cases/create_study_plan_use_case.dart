import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/create_update/create_study_plan_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_plan_params.dart';

class CreateStudyPlanUseCase {
  final StudyPlanRepository repository;

  const CreateStudyPlanUseCase(this.repository);

  Future<Either<Failure, CreateStudyPlanResponseEntity>> call(
    CreateStudyPlanParams params,
  ) {
    debugPrint('============ CreateStudyPlanUseCase.call ============');
    debugPrint('→ params: $params');

    return repository.createStudyPlan(params: params);
  }
}
