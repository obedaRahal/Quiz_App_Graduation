import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';

class StudyPlansResponseEntity {
  final bool success;
  final String title;
  final int plansCount;
  final List<ManagedStudyPlanEntity> plans;
  final int statusCode;

  const StudyPlansResponseEntity({
    required this.success,
    required this.title,
    required this.plansCount,
    required this.plans,
    required this.statusCode,
  });

  bool get hasPlans => plans.isNotEmpty;

  bool get isEmpty => plans.isEmpty;
}