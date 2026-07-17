enum StudyPlanHomeMockScenario { noPlan, planWithoutTasks, planWithTasks }

extension StudyPlanHomeMockScenarioX on StudyPlanHomeMockScenario {
  String get title {
    switch (this) {
      case StudyPlanHomeMockScenario.noPlan:
        return 'لا توجد خطة';

      case StudyPlanHomeMockScenario.planWithoutTasks:
        return 'خطة بدون مهام';

      case StudyPlanHomeMockScenario.planWithTasks:
        return 'خطة مع مهام';
    }
  }
}
