import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/data/models/laboratory_exam_session_model.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_exam_session_card.dart';

class LaboratoryExamSessionsSection extends StatelessWidget {
  const LaboratoryExamSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: SizeConfig.h(0.012),
        bottom: SizeConfig.h(0.03),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyExamSessions.length,
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.018)),
      itemBuilder: (context, index) {
        return LaboratoryExamSessionCard(
          item: dummyExamSessions[index],
        );
      },
    );
  }
}