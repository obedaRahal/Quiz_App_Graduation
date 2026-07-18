import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_tasks_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_tasks_params.dart';

class GetStudyPlanDetailsTasksUseCase {
  final StudyPlanRepository repository;

  const GetStudyPlanDetailsTasksUseCase(this.repository);

  Future<Either<Failure, StudyPlanDetailsTasksEntity>> call(
    GetStudyPlanDetailsTasksParams params,
  ) async {
    debugPrint('============ GetStudyPlanDetailsTasksUseCase ============');
    debugPrint('→ params: $params');

    final result = await repository.getStudyPlanDetailsTasks(params: params);

    result.fold(
      (failure) {
        debugPrint('✗ tasks use case failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');
      },
      (response) {
        debugPrint('✓ tasks use case success');
        debugPrint('→ old: ${response.old.count}');
        debugPrint('→ upcoming: ${response.upcoming.count}');
        debugPrint('→ completed: ${response.completed.count}');
      },
    );

    debugPrint('========================================================');

    return result;
  }
}
