import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';

class ActiveStudyPlanCard extends StatelessWidget {
  final StudyPlanSummaryEntity plan;
  final VoidCallback? onTap;
  final Color bottomText;
  final Color bottomBg;

  const ActiveStudyPlanCard({
    super.key,
    required this.plan,
    this.onTap,
    required this.bottomText,
    required this.bottomBg,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        //borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            CustomBackgroundWithChild(
              width: double.infinity,
              border: Border.all(color: bottomText),
              borderRadius: BorderRadius.circular(10),
              backgroundColor: bottomBg,

              child: Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.14)),
                  _PlanDateFooter(
                    startDate: plan.startDate,
                    endDate: plan.endDate,
                    bottomBg: bottomText,
                  ),
                ],
              ),
            ),
            CustomBackgroundWithChild(
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context
                    .appColors
                    .borderFieldColorNLightToborderFieldColorNDark,
                width: 2,
              ),
              backgroundColor: AppPalette.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.03),
                  vertical: SizeConfig.w(0.018),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _PlanTitleRow(
                      plan: plan,
                      onEditTap: () {
                        debugPrint("on edit tap ");
                      },
                    ),
                    SizedBox(height: SizeConfig.h(0.018)),
                    _PlanInformationRow(plan: plan),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTitleRow extends StatelessWidget {
  final StudyPlanSummaryEntity plan;
  final VoidCallback onEditTap;

  const _PlanTitleRow({required this.plan, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButtonWidget(
              onTap: onEditTap,
              child: CustomAppImage(
                path: AppImage.feather,
                height: SizeConfig.h(0.025),
              ),
            ),
            CustomTextWidget(
              plan.emoji,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: SizeConfig.text(0.05),
              fontFamily: AppFont.elMessiriBold,
              color: context.appColors.blackToGrey2Dark,
            ),
          ],
        ),
        Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Flexible(
                    child: CustomTextWidget(
                      plan.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontSize: SizeConfig.text(0.042),
                      fontFamily: AppFont.elMessiriBold,
                      color: context.appColors.blackToGrey2Dark,
                    ),
                  ),

                  if (plan.isDefault) ...[
                    SizedBox(width: SizeConfig.w(0.012)),
                    CustomTextWidget(
                      '(الافتراضية)',
                      fontSize: SizeConfig.text(0.032),
                      fontFamily: AppFont.elMessiriSemiBold,
                      color: context.appColors.primaryToPrimaryDark,
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.025)),

            Icon(
              Icons.eco_outlined,
              size: SizeConfig.h(0.022),
              color: context.appColors.greyToGreyMediumDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanInformationRow extends StatelessWidget {
  final StudyPlanSummaryEntity plan;

  const _PlanInformationRow({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PlanInfoItem(value: _studyTimeText(plan)),
        _PlanInfoItem(value: '${plan.subjectsCount} مواد ضمن الخطة'),
        _PlanInfoItem(value: 'مدتها ${plan.durationDays} يوم'),
      ],
    );
  }

  String _studyTimeText(StudyPlanSummaryEntity plan) {
    if (plan.dailyStudyHours > 0) {
      return '${plan.dailyStudyHours} ساعة';
    }

    return '${plan.dailyStudyMinutes} دقيقة';
  }
}

class _PlanInfoItem extends StatelessWidget {
  final String value;

  const _PlanInfoItem({required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      value,
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      fontSize: SizeConfig.text(0.031),
      fontFamily: AppFont.elMessiriSemiBold,
      color: AppPalette.greyMedium,
    );
  }
}

class _PlanDateFooter extends StatelessWidget {
  final String startDate;
  final String endDate;
  final Color bottomBg;

  const _PlanDateFooter({
    required this.startDate,
    required this.endDate,
    required this.bottomBg,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.009),
      ),
      backgroundColor: Colors.transparent,

      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PlanDateText(label: 'بدأت', value: startDate, bottomBg: bottomBg),
          _PlanDateText(label: 'تنتهي', value: endDate, bottomBg: bottomBg),
        ],
      ),
    );
  }
}

class _PlanDateText extends StatelessWidget {
  final String label;
  final String value;
  final Color bottomBg;

  const _PlanDateText({
    required this.label,
    required this.value,
    required this.bottomBg,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      '$label $value',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      fontSize: SizeConfig.text(0.03),
      fontFamily: AppFont.elMessiriSemiBold,
      color: bottomBg,
    );
  }
}
