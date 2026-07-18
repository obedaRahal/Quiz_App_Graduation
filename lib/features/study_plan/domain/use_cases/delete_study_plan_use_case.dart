import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/delete_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_plan_params.dart';

class DeleteStudyPlanUseCase {
  final StudyPlanRepository repository;

  const DeleteStudyPlanUseCase({required this.repository});

  Future<Either<Failure, DeleteStudyPlanEntity>> call(
    DeleteStudyPlanParams params,
  ) async {
    debugPrint('============ DeleteStudyPlanUseCase.call ============');
    debugPrint('→ params: $params');

    final result = await repository.deleteStudyPlan(params);

    result.fold(
      (failure) {
        debugPrint('✗ DeleteStudyPlanUseCase failure');
        debugPrint('→ failure: $failure');
      },
      (entity) {
        debugPrint('✓ DeleteStudyPlanUseCase success');
        debugPrint('→ entity: $entity');
      },
    );

    debugPrint('=====================================================');

    return result;
  }
}
