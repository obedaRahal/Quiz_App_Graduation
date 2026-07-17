class GetStudyPlanDetailsOverviewParams {
  final int planId;

  const GetStudyPlanDetailsOverviewParams({required this.planId});

  bool get isValid => planId > 0;

  @override
  String toString() {
    return 'GetStudyPlanDetailsOverviewParams('
        'planId: $planId'
        ')';
  }
}
