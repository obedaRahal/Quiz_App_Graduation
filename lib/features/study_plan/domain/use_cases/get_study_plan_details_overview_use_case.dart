import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';

class GetStudyPlanDetailsOverviewUseCase {
  final StudyPlanRepository repository;

  const GetStudyPlanDetailsOverviewUseCase(this.repository);

  Future<Either<Failure, StudyPlanDetailsOverviewEntity>> call(
    GetStudyPlanDetailsOverviewParams params,
  ) async {
    debugPrint('============ GetStudyPlanDetailsOverviewUseCase ============');
    debugPrint('→ params: $params');

    final result = await repository.getStudyPlanDetailsOverview(params: params);

    result.fold(
      (failure) {
        debugPrint('✗ GetStudyPlanDetailsOverviewUseCase failure');
        debugPrint('→ message: ${failure.message}');
      },
      (overview) {
        debugPrint('✓ GetStudyPlanDetailsOverviewUseCase success');
        debugPrint('→ planId: ${overview.id}');
        debugPrint('→ subjects: ${overview.subjects.count}');
      },
    );

    debugPrint('===========================================================');

    return result;
  }
}
