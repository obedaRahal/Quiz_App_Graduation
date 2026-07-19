import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_daily_task_card.dart';

class StudyPlanTasksGroupSection extends StatelessWidget {
  final String title;
  final int count;
  final List<StudyPlanDailyTaskEntity> tasks;
  final bool isExpanded;
  final VoidCallback onToggle;

  const StudyPlanTasksGroupSection({
    super.key,
    required this.title,
    required this.count,
    required this.tasks,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.008)),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      CustomTextWidget(
                        title,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.041),
                        color: context.appColors.blackToGrey2Dark,
                      ),
                      SizedBox(width: SizeConfig.w(0.012)),
                      CustomTextWidget(
                        '($count مهمة)',
                        fontFamily: AppFont.elMessiriSemiBold,
                        fontSize: SizeConfig.text(0.03),
                        color: context.appColors.primaryToPrimaryDark,
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: !isExpanded
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: SizeConfig.h(0.01)),
                  child: tasks.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.h(0.02),
                          ),
                          child: CustomTextWidget(
                            'لا توجد مهام في هذا القسم',
                            color: AppPalette.greyMedium,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          children: tasks.map((task) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: SizeConfig.h(0.014),
                              ),
                              child: StudyPlanDailyTaskCard(
                                task: task,
                                isUpdating: false,
                                onStatusToggle: () {
                                  debugPrint(
                                    '============ Task Checkbox Pressed ============',
                                  );
                                  debugPrint('→ display only');
                                  debugPrint('→ taskId: ${task.id}');
                                  debugPrint('→ title: ${task.title}');
                                  debugPrint(
                                    '================================================',
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                ),
        ),
      ],
    );
  }
}
