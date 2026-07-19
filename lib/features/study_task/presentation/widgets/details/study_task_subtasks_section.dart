import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';

class StudyTaskSubtasksSection extends StatelessWidget {
  final List<StudySubTaskEntity> subtasks;
  final StudyTaskSubtasksCountEntity count;
  final ValueChanged<int> onSubTaskTap;

  const StudyTaskSubtasksSection({
    super.key,
    required this.subtasks,
    required this.count,
    required this.onSubTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'المهام الفرعية',
          textAlign: TextAlign.right,
          fontSize: SizeConfig.text(0.05),
          fontFamily: AppFont.elMessiriBold,
          color: appColors.blackToGrey2Dark,
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: appColors.greyToGreyMediumDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          child: subtasks.isEmpty
              ? _EmptySubTasks(countLabel: count.label)
              : Column(
                  children: List.generate(subtasks.length, (index) {
                    final subTask = subtasks[index];
                    final isLast = index == subtasks.length - 1;

                    return Column(
                      children: [
                        _SubTaskTile(
                          subTask: subTask,
                          onTap: () {
                            onSubTaskTap(subTask.id);
                          },
                        ),
                        if (!isLast)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.035),
                            ),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: appColors
                                  .borderFieldColorNLightToborderFieldColorNDark,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }
}


class _SubTaskTile extends StatelessWidget {
  final StudySubTaskEntity subTask;
  final VoidCallback onTap;

  const _SubTaskTile({
    required this.subTask,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.014),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _SubTaskStatusCircle(
              isCompleted: subTask.isCompleted,
            ),

            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: CustomTextWidget(
                subTask.title,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                fontSize: SizeConfig.text(0.032),
                fontFamily:
                    AppFont.elMessiriSemiBold,
                color: subTask.isCompleted
                    ? AppPalette.greyMedium
                    : appColors.blackToGrey2Dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubTaskStatusCircle extends StatelessWidget {
  final bool isCompleted;

  const _SubTaskStatusCircle({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const completedColor = Color(0xff6EDC5F);
    const inactiveColor = Color(0xffC7C8CC);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: SizeConfig.h(0.025),
      height: SizeConfig.h(0.025),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? completedColor
            : Colors.transparent,
        border: Border.all(
          color: isCompleted
              ? completedColor
              : inactiveColor,
          width: 1.5,
        ),
      ),
      child: isCompleted
          ? Icon(
              Icons.check_rounded,
              size: SizeConfig.h(0.017),
              color: Colors.white,
            )
          : null,
    );
  }
}

class _EmptySubTasks extends StatelessWidget {
  final String countLabel;

  const _EmptySubTasks({
    required this.countLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(0.025),
      ),
      child: Center(
        child: CustomTextWidget(
          'لا توجد مهام فرعية',
          fontSize: SizeConfig.text(0.03),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
      ),
    );
  }
}