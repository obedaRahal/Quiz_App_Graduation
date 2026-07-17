import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_body.dart';

class StudyPlanDetailsView extends StatelessWidget {
  final StudyPlanSummaryEntity plan;

  const StudyPlanDetailsView({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: StudyPlanDetailsBody(plan: plan)),
    );
  }
}
