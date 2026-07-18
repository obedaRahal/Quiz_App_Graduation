import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';

class StudyPlanMutationResult {
  final StudyPlanSummaryEntity? updatedPlan;

  const StudyPlanMutationResult.created() : updatedPlan = null;

  const StudyPlanMutationResult.updated(StudyPlanSummaryEntity plan)
    : updatedPlan = plan;
}
