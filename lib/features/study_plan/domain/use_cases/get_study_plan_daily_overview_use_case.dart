import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';

class GetStudyPlanDailyOverviewUseCase {
  final StudyPlanRepository repository;

  const GetStudyPlanDailyOverviewUseCase(
    this.repository,
  );

  Future<Either<Failure, StudyPlanOverviewEntity>> call(
    GetStudyPlanDailyOverviewParams params,
  ) {
    return repository.getDailyTasksOverview(
      params: params,
    );
  }
}