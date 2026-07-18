import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/create_update/create_study_plan_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/update_study_plan_params.dart';

class UpdateStudyPlanUseCase {
  final StudyPlanRepository repository;

  const UpdateStudyPlanUseCase(this.repository);

  Future<Either<Failure, CreateStudyPlanResponseEntity>> call(
    UpdateStudyPlanParams params,
  ) {
    debugPrint('============ UpdateStudyPlanUseCase.call ============');
    debugPrint('→ planId: ${params.planId}');
    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toBody()}');

    return repository.updateStudyPlan(params: params);
  }
}
