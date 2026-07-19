class CreateStudyTaskArgs {
  final int planId;

  const CreateStudyTaskArgs({
    required this.planId,
  });

  bool get isValid => planId > 0;

  @override
  String toString() {
    return 'CreateStudyTaskArgs(planId: $planId)';
  }
}