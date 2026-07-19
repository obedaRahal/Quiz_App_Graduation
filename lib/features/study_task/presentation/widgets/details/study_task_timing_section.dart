
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';

class TaskTimingSession extends StatelessWidget {
  final StudyTaskTimingInfoEntity timingInfo;

  const TaskTimingSession({super.key, required this.timingInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'تاريخ ومدة المهمة',
          color: AppPalette.black,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.05),
        ),
        SizedBox(width: SizeConfig.h(0.1)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: _MetaInfoItem(
                title: 'الوقت',
                value: timingInfo.startTime,
                icon: FontAwesomeIcons.clockRotateLeft,
              ),
            ),

            SizedBox(width: SizeConfig.w(0.04)),

            Expanded(
              child: _MetaInfoItem(
                title: 'المدة',
                value: timingInfo.duration.label,
                icon: FontAwesomeIcons.hourglassHalf,
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.02)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: _MetaInfoItem(
                title: 'التكرار',
                value: timingInfo.repeatPattern,
                icon: FontAwesomeIcons.repeat,
              ),
            ),

            SizedBox(width: SizeConfig.w(0.04)),

            Expanded(
              child: _MetaInfoItem(
                title: 'تذكيرات المهمة',
                value: timingInfo.reminder.label,
                icon: FontAwesomeIcons.bell,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final FaIconData icon;

  const _MetaInfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      width: SizeConfig.w(0.42),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBackgroundWithChild(
            backgroundColor: appColors.primarySoftTogreyLightDark,
            childHorizontalPad: SizeConfig.w(0.02),
            childVerticalPad: SizeConfig.h(0.01),
            borderRadius: BorderRadius.circular(15),
            child: FaIcon(
              icon,
              size: SizeConfig.h(0.025),
              color: appColors.primaryToPrimaryDark,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.015)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  color: appColors.blackTogreyMedium,
                  fontSize: SizeConfig.text(0.027),
                  fontFamily: AppFont.elMessiriBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomTextWidget(
                  value,
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.027),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

