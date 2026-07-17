import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_stat_card.dart';

class StudyPlanDetailsStatisticsSection
    extends StatelessWidget {
  final StudyPlanSummaryEntity plan;

  final String totalTasksImage;
  final String completedTasksImage;
  final String pendingTasksImage;

  const StudyPlanDetailsStatisticsSection({
    super.key,
    required this.plan,
    required this.totalTasksImage,
    required this.completedTasksImage,
    required this.pendingTasksImage,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final statistics = plan.statistics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextWidget(
          'إحصائية الخطة',
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.043),
          color: appColors.blackToGrey2Dark,
          textAlign: TextAlign.right,
        ),

        SizedBox(height: SizeConfig.h(0.014)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: StudyPlanDetailsStatCard(
                imagePath: totalTasksImage,
                value: statistics.tasksCount,
                title: 'مهمة قائمة',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: StudyPlanDetailsStatCard(
                imagePath: completedTasksImage,
                value:
                    statistics.completedTasksCount,
                title: 'مهمة منجزة',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: StudyPlanDetailsStatCard(
                imagePath: pendingTasksImage,
                value:
                    statistics.pendingTasksCount,
                title: 'مهمة متبقية',
              ),
            ),
          ],
        ),
      ],
    );
  }
}