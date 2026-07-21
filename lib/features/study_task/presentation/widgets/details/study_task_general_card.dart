import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';

class StudyTaskGeneralDetailsCard extends StatelessWidget {
  final StudyTaskDetailsDataEntity task;
  final VoidCallback onStatusToggle;

  const StudyTaskGeneralDetailsCard({
    super.key,
    required this.task,
    required this.onStatusToggle,
    required StudyTaskDetailsDataEntity taskDetails,
  });

  @override
  Widget build(BuildContext context) {
    final basicInfo = task.basicInfo;
    final statusStyle = _resolveStatusStyle(basicInfo.status);
    final priorityColor = _resolvePriorityColor(basicInfo.priority);

    final isCompleted = basicInfo.status == StudyTaskStatus.completed;

    final borderColor = isCompleted
        ? AppPalette.green
        : context.appColors.borderFieldColorNLightToborderFieldColorNDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.greyToGreyMediumDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isCompleted ? 1.7 : 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.028),
          vertical: SizeConfig.h(0.014),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TaskHeader(
              title: basicInfo.title,
              statusStyle: statusStyle,
              isCompleted: isCompleted,
              onStatusToggle: onStatusToggle,
            ),
            SizedBox(height: SizeConfig.h(0.012)),
            const CustomDivider(height: 1, thickness: 2),
            SizedBox(height: SizeConfig.h(0.012)),
            _TaskDetailsRow(task: task, priorityColor: priorityColor),
            SizedBox(height: SizeConfig.h(0.016)),
            const CustomDivider(height: 1, thickness: 2),
            SizedBox(height: SizeConfig.h(0.016)),
            _TaskDescriptionSection(description: basicInfo.description),
            SizedBox(height: SizeConfig.h(0.018)),
            _TaskSubjectSection(subjectName: basicInfo.subject.name),
          ],
        ),
      ),
    );
  }

  Color _resolvePriorityColor(StudyTaskPriority priority) {
    switch (priority) {
      case StudyTaskPriority.low:
        return const Color(0xff2ECC71);

      case StudyTaskPriority.medium:
        return const Color(0xffF39C3D);

      case StudyTaskPriority.high:
        return const Color(0xffEF5350);

      case StudyTaskPriority.unknown:
        return const Color.fromARGB(255, 70, 68, 68);
    }
  }

  _TaskStatusStyle _resolveStatusStyle(StudyTaskStatus status) {
    switch (status) {
      case StudyTaskStatus.todo:
        return const _TaskStatusStyle(
          title: 'للقيام',
          backgroundColor: Color(0xff909196),
          textColor: Colors.white,
        );

      case StudyTaskStatus.inProgress:
        return const _TaskStatusStyle(
          title: 'قيد المعالجة',
          backgroundColor: Color(0xff5B9CFF),
          textColor: Colors.white,
        );

      case StudyTaskStatus.completed:
        return const _TaskStatusStyle(
          title: 'تم إنجازها',
          backgroundColor: Color(0xff2ECC71),
          textColor: Colors.white,
        );
      case StudyTaskStatus.missed:
        return _TaskStatusStyle(
          title: 'فائتة',
          backgroundColor: AppPalette.red,
          textColor: Colors.white,
        );
    }
  }
}

class _TaskHeader extends StatelessWidget {
  final String title;
  final _TaskStatusStyle statusStyle;
  final bool isCompleted;
  final VoidCallback onStatusToggle;

  const _TaskHeader({
    required this.title,
    required this.statusStyle,
    required this.isCompleted,
    required this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CustomTextWidget(
            title,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.041),
            fontFamily: AppFont.elMessiriBold,
            color: context.appColors.blackToGrey2Dark,
          ),
        ),
        SizedBox(width: SizeConfig.w(0.018)),
        _TaskStatusBadge(style: statusStyle),
        SizedBox(width: SizeConfig.w(0.018)),
        _TaskStatusCheckBox(value: isCompleted, onTap: onStatusToggle),
      ],
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  final _TaskStatusStyle style;

  const _TaskStatusBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.023),
        vertical: SizeConfig.h(0.003),
      ),
      backgroundColor: style.backgroundColor,
      borderRadius: BorderRadius.circular(3),
      child: CustomTextWidget(
        style.title,
        maxLines: 1,
        fontSize: SizeConfig.text(0.025),
        color: context.appColors.whiteToblack,
      ),
    );
  }
}

class _TaskStatusCheckBox extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _TaskStatusCheckBox({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xff2ECC71);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: SizeConfig.h(0.025),
        height: SizeConfig.h(0.025),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: value ? activeColor : AppPalette.greyMedium,
            width: 1.4,
          ),
        ),
        child: value
            ? Icon(
                Icons.check_rounded,
                size: SizeConfig.h(0.018),
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

class _TaskDetailsRow extends StatelessWidget {
  final StudyTaskDetailsDataEntity task;
  final Color priorityColor;

  const _TaskDetailsRow({required this.task, required this.priorityColor});

  @override
  Widget build(BuildContext context) {
    final basicInfo = task.basicInfo;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _TaskInfoColumn(
            title: 'رقم المهمة',
            value: '#${basicInfo.taskNumber}',
            valueColor: context.appColors.primaryToPrimaryDark,
          ),
        ),
        Expanded(
          child: _TaskInfoColumn(
            title: 'المهام الفرعية',
            value: basicInfo.subtasksCount.total > 0
                ? basicInfo.subtasksCount.label
                : 'لا يوجد',
          ),
        ),
        Expanded(
          child: _TaskDateColumn(
            startDate: task.basicInfo.startDate,
            endDate: task.basicInfo.endDate,
            // _resolveEndTime(task),
          ),
        ),
        _TaskInfoColumn(
          title: 'الأولوية',
          value: basicInfo.priority.label,
          valueColor: priorityColor,
        ),
      ],
    );
  }
}

class _TaskInfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _TaskInfoColumn({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          title,
          maxLines: 1,
          fontSize: SizeConfig.text(0.028),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        CustomTextWidget(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          fontSize: SizeConfig.text(0.03),
          fontFamily: AppFont.elMessiriBold,
          color: valueColor ?? context.appColors.blackToGrey2Dark,
        ),
      ],
    );
  }
}

class _TaskDateColumn extends StatelessWidget {
  final String startDate;
  final String endDate;

  const _TaskDateColumn({required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final hasStartDate = startDate.trim().isNotEmpty;
    final hasEndDate = endDate.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'التاريخ',
          maxLines: 1,
          fontSize: SizeConfig.text(0.028),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        CustomTextWidget(
          'من ${hasStartDate ? startDate : 'غير محدد'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          fontSize: SizeConfig.text(0.028),
          fontFamily: AppFont.elMessiriBold,
          color: context.appColors.blackToGrey2Dark,
        ),
        SizedBox(height: SizeConfig.h(0.003)),
        CustomTextWidget(
          'إلى ${hasEndDate ? endDate : 'غير محدد'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          fontSize: SizeConfig.text(0.028),
          fontFamily: AppFont.elMessiriBold,
          color: context.appColors.blackToGrey2Dark,
        ),
      ],
    );
  }
}

class _TaskDescriptionSection extends StatelessWidget {
  final String description;

  const _TaskDescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    final value = description.trim().isEmpty
        ? 'لا يوجد وصف لهذه المهمة'
        : description.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'وصف المهمة',
          textAlign: TextAlign.right,
          fontSize: SizeConfig.text(0.032),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
        SizedBox(height: SizeConfig.h(0.006)),
        Align(
          alignment: Alignment.centerRight,
          child: CustomTextWidget(
            value,
            textAlign: TextAlign.right,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.033),
            fontFamily: AppFont.elMessiriBold,
            color: context.appColors.blackToGrey2Dark,
          ),
        ),
      ],
    );
  }
}

class _TaskSubjectSection extends StatelessWidget {
  final String subjectName;

  const _TaskSubjectSection({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final value = subjectName.trim().isEmpty
        ? 'مادة غير محددة'
        : subjectName.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'مادة المهمة',
          textAlign: TextAlign.right,
          fontSize: SizeConfig.text(0.032),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
        SizedBox(height: SizeConfig.h(0.008)),
        CustomBackgroundWithChild(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.025),
            vertical: SizeConfig.h(0.005),
          ),
          borderRadius: BorderRadius.circular(4),

          backgroundColor: context.appColors.primaryToPrimaryDark,
          child: CustomTextWidget(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.032),
            color: context.appColors.whiteToblack,
          ),
        ),
      ],
    );
  }
}

class _TaskStatusStyle {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const _TaskStatusStyle({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });
}
