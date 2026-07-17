import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plans_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';

class GetStudyPlansUseCase {
  final StudyPlanRepository repository;

  const GetStudyPlansUseCase(this.repository);

  Future<Either<Failure, StudyPlansResponseEntity>> call(
    GetStudyPlansParams params,
  ) {
    debugPrint('============ GetStudyPlansUseCase.call ============');
    debugPrint('→ params: $params');
    debugPrint('→ queryParameters: ${params.toQueryParameters()}');

    return repository.getStudyPlans(params: params);
  }
}
