import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/app_time_formatter.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';

class StudyPlanDailyTaskCard extends StatelessWidget {
  final StudyPlanDailyTaskEntity task;
  final bool isUpdating;
  final VoidCallback onStatusToggle;
  final VoidCallback? onTap;
  final bool showStatusCheckBox;

  const StudyPlanDailyTaskCard({
    super.key,
    required this.task,
    required this.isUpdating,
    required this.onStatusToggle,
    this.onTap,
    this.showStatusCheckBox = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _resolveStatusStyle(task.status);
    final priorityColor = _resolvePriorityColor(task.parsedPriority);

    final borderColor = task.isCompleted
        ? AppPalette.green
        : context.appColors.borderFieldColorNLightToborderFieldColorNDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.greyToGreyMediumDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: task.isCompleted ? 1.7 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.028),
              vertical: SizeConfig.h(0.012),
            ),
            child: Column(
              children: [
                _TaskHeader(
                  task: task,
                  statusStyle: statusStyle,
                  isUpdating: isUpdating,
                  onStatusToggle: onStatusToggle,
                  showStatusCheckBox: showStatusCheckBox,
                ),
                SizedBox(height: SizeConfig.h(0.012)),
                CustomDivider(height: 1, thickness: 2),
                SizedBox(height: SizeConfig.h(0.012)),
                _TaskDetailsRow(task: task, priorityColor: priorityColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolvePriorityColor(StudyPlanTaskPriority priority) {
    switch (priority) {
      case StudyPlanTaskPriority.low:
        return const Color(0xff2ECC71);

      case StudyPlanTaskPriority.medium:
        return const Color(0xffF39C3D);

      case StudyPlanTaskPriority.high:
        return const Color(0xffEF5350);

      case StudyPlanTaskPriority.unknown:
        return const Color(0xff8E9099);
    }
  }

  _TaskStatusStyle _resolveStatusStyle(String value) {
    final normalized = value.trim();

    switch (normalized) {
      case 'للقيام':
        return const _TaskStatusStyle(
          title: 'للقيام',
          backgroundColor: Color(0xff909196),
          textColor: Colors.white,
        );

      case 'قيد المعالجة':
      case 'قيد التنفيذ':
        return const _TaskStatusStyle(
          title: 'قيد المعالجة',
          backgroundColor: Color(0xff5B9CFF),
          textColor: Colors.white,
        );

      case 'تم الإنجاز':
      case 'منجزة':
      case 'مكتملة':
        return const _TaskStatusStyle(
          title: 'تم إنجازها',
          backgroundColor: Color(0xff2ECC71),
          textColor: Colors.white,
        );

      case 'فائتة':
      case 'فشلت':
        return const _TaskStatusStyle(
          title: 'فائتة',
          backgroundColor: Color(0xffEF5350),
          textColor: Colors.white,
        );

      default:
        return _TaskStatusStyle(
          title: normalized.isEmpty ? 'غير معروفة' : normalized,
          backgroundColor: const Color(0xff909196),
          textColor: Colors.white,
        );
    }
  }
}

class _TaskHeader extends StatelessWidget {
  final StudyPlanDailyTaskEntity task;
  final _TaskStatusStyle statusStyle;
  final bool isUpdating;
  final VoidCallback onStatusToggle;
  final bool showStatusCheckBox;

  const _TaskHeader({
    required this.task,
    required this.statusStyle,
    required this.isUpdating,
    required this.onStatusToggle,
    required this.showStatusCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextWidget(
            textAlign: TextAlign.right,
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.041),
            fontFamily: AppFont.elMessiriBold,
            color: context.appColors.blackToGrey2Dark,
          ),
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        _TaskStatusBadge(style: statusStyle),

        if (showStatusCheckBox) ...[
          SizedBox(width: SizeConfig.w(0.018)),

          _TaskStatusCheckBox(
            status: task.status,
            isLoading: isUpdating,
            onTap: onStatusToggle,
          ),
        ],
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
  final String status;
  final bool isLoading;
  final VoidCallback onTap;

  const _TaskStatusCheckBox({
    required this.status,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _resolveCheckBoxStyle(status);

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: SizeConfig.h(0.025),
        height: SizeConfig.h(0.025),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: style.borderColor, width: 1.4),
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(3),
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: style.loadingColor,
                ),
              )
            : style.showIcon
            ? Icon(
                style.icon,
                size: SizeConfig.h(0.018),
                color: style.iconColor,
              )
            : null,
      ),
    );
  }

  _TaskCheckBoxStyle _resolveCheckBoxStyle(String value) {
    final normalized = value.trim();

    switch (normalized) {
      case 'للقيام':
        return const _TaskCheckBoxStyle(
          backgroundColor: Colors.transparent,
          borderColor: AppPalette.greyMedium,
          iconColor: Colors.transparent,
          loadingColor: AppPalette.greyMedium,
          showIcon: false,
          icon: Icons.check_rounded,
        );

      case 'قيد المعالجة':
      case 'قيد التنفيذ':
        return const _TaskCheckBoxStyle(
          backgroundColor: Color(0xff5B9CFF),
          borderColor: Color(0xff5B9CFF),
          iconColor: Colors.white,
          loadingColor: Colors.white,
          showIcon: true,
          icon: Icons.more_horiz_rounded,
        );

      case 'تم الإنجاز':
      case 'منجزة':
      case 'مكتملة':
        return const _TaskCheckBoxStyle(
          backgroundColor: Color(0xff2ECC71),
          borderColor: Color(0xff2ECC71),
          iconColor: Colors.white,
          loadingColor: Colors.white,
          showIcon: true,
          icon: Icons.check_rounded,
        );

      default:
        return const _TaskCheckBoxStyle(
          backgroundColor: Colors.transparent,
          borderColor: AppPalette.greyMedium,
          iconColor: Colors.transparent,
          loadingColor: AppPalette.greyMedium,
          showIcon: false,
          icon: Icons.check_rounded,
        );
    }
  }
}

class _TaskCheckBoxStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color loadingColor;
  final bool showIcon;
  final IconData icon;

  const _TaskCheckBoxStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.loadingColor,
    required this.showIcon,
    required this.icon,
  });
}

class _TaskDetailsRow extends StatelessWidget {
  final StudyPlanDailyTaskEntity task;
  final Color priorityColor;

  const _TaskDetailsRow({required this.task, required this.priorityColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TaskInfoColumn(
            title: 'رقم المهمة',
            value: '#${task.taskNumber}',
            valueColor: context.appColors.primaryToPrimaryDark,
          ),
        ),

        Expanded(
          child: _TaskInfoColumn(
            title: 'المهام الفرعية',
            value: task.hasSubtasks ? task.subtasks.label : 'لا يوجد',
          ),
        ),

        if (task.hasTime)
          Expanded(
            child: _TaskTimeColumn(start: task.time.start, end: task.time.end),
          ),

        _TaskInfoColumn(
          title: 'الأولوية',
          value: task.priority,
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

class _TaskTimeColumn extends StatelessWidget {
  final String start;
  final String end;

  const _TaskTimeColumn({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'الوقت',
          maxLines: 1,
          fontSize: SizeConfig.text(0.028),
          fontFamily: AppFont.elMessiriSemiBold,
          color: AppPalette.greyMedium,
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextWidget(
              AppTimeFormatter.format(end),
              maxLines: 1,
              fontSize: SizeConfig.text(0.028),
              fontFamily: AppFont.elMessiriBold,
              color: context.appColors.blackToGrey2Dark,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.008)),
              child: Icon(
                Icons.arrow_downward,
                size: SizeConfig.h(0.016),
                color: AppPalette.greyMedium,
              ),
            ),
            CustomTextWidget(
              AppTimeFormatter.format(start),
              maxLines: 1,
              fontSize: SizeConfig.text(0.028),
              fontFamily: AppFont.elMessiriBold,
              color: context.appColors.blackToGrey2Dark,
            ),
          ],
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
