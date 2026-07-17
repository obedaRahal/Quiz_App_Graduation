import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsProgressCard
    extends StatelessWidget {
  final StudyPlanDetailsProgressEntity progress;

  const StudyPlanDetailsProgressCard({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        SizeConfig.w(0.035),
      ),
      decoration: BoxDecoration(
        color: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: appColors
              .borderFieldColorNLightToborderFieldColorNDark,
        ),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: CustomTextWidget(
                  'مضى ${progress.elapsedLabel}',
                  fontFamily:
                      AppFont.elMessiriSemiBold,
                  fontSize: SizeConfig.text(0.031),
                  color: appColors.blackToGrey2Dark,
                  textAlign: TextAlign.right,
                ),
              ),

              CustomTextWidget(
                '${progress.remainingDays} أيام متبقية',
                fontFamily:
                    AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.031),
                color: appColors.blackToGrey2Dark,
                textAlign: TextAlign.left,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.013)),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              CustomTextWidget(
                progress.completedPercentageLabel,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.029),
                color: appColors.primaryToPrimaryDark,
              ),

              SizedBox(width: SizeConfig.w(0.025)),

              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress.progressValue,
                    minHeight: SizeConfig.h(0.012),
                    backgroundColor: appColors
                        .primarySoftTogreyLightDark,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      appColors.primaryToPrimaryDark,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.013)),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: _ProgressDateItem(
                  title: 'البداية',
                  value: progress.startDate,
                  alignment: TextAlign.right,
                ),
              ),

              Expanded(
                child: _ProgressDateItem(
                  title: 'النهاية',
                  value: progress.endDate,
                  alignment: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressDateItem extends StatelessWidget {
  final String title;
  final String value;
  final TextAlign alignment;

  const _ProgressDateItem({
    required this.title,
    required this.value,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment:
          alignment == TextAlign.right
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.025),
          color: AppPalette.greyMedium,
          textAlign: alignment,
        ),
        CustomTextWidget(
          value,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.027),
          color: appColors.blackToGrey2Dark,
          textAlign: alignment,
        ),
      ],
    );
  }
}