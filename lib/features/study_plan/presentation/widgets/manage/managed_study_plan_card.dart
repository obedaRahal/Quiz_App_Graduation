import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';

class ManagedStudyPlanCard extends StatelessWidget {
  final ManagedStudyPlanEntity plan;
  final VoidCallback onTap;

  const ManagedStudyPlanCard({
    super.key,
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progress = plan.statistics.completionProgress;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(SizeConfig.w(0.035)),
          decoration: BoxDecoration(
            color: appColors.whiteToblack,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.w(0.12),
                    height: SizeConfig.w(0.12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: appColors.primaryToPrimaryDark.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: CustomTextWidget(
                      plan.displayEmoji,
                      fontSize: SizeConfig.text(0.065),
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.025)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              child: CustomTextWidget(
                                plan.title,
                                fontFamily: AppFont.elMessiriBold,
                                fontSize: SizeConfig.text(0.037),
                                color: appColors.blackToGrey2Dark,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (plan.isDefault) ...[
                              SizedBox(width: SizeConfig.w(0.015)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.w(0.02),
                                  vertical: SizeConfig.h(0.003),
                                ),
                                decoration: BoxDecoration(
                                  color: appColors.primaryToPrimaryDark
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CustomTextWidget(
                                  'افتراضية',
                                  fontSize: SizeConfig.text(0.024),
                                  color: appColors.primaryToPrimaryDark,
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: SizeConfig.h(0.006)),

                        CustomTextWidget(
                          '${plan.subjectsCount} مواد • ${plan.dailyStudyHours} ساعات يوميًا',
                          fontSize: SizeConfig.text(0.028),
                          color: AppPalette.greyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.015)),

                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.text(0.04),
                    color: AppPalette.greyMedium,
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: _PlanInfoItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'البداية',
                      value: plan.startDate,
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.02)),

                  Expanded(
                    child: _PlanInfoItem(
                      icon: Icons.event_available_outlined,
                      title: 'النهاية',
                      value: plan.endDate,
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  CustomTextWidget(
                    'التقدم',
                    fontFamily: AppFont.elMessiriSemiBold,
                    fontSize: SizeConfig.text(0.028),
                    color: appColors.blackToGrey2Dark,
                  ),

                  const Spacer(),

                  CustomTextWidget(
                    '${plan.statistics.completedTasksCount}/${plan.statistics.tasksCount}',
                    fontSize: SizeConfig.text(0.027),
                    color: AppPalette.greyMedium,
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(0.007)),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: SizeConfig.h(0.007),
                  backgroundColor: appColors.primaryToPrimaryDark.withValues(
                    alpha: 0.12,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    appColors.primaryToPrimaryDark,
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.h(0.012)),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    size: SizeConfig.text(0.04),
                    color: appColors.primaryToPrimaryDark,
                  ),

                  SizedBox(width: SizeConfig.w(0.012)),

                  CustomTextWidget(
                    _remainingLabel(plan),
                    fontSize: SizeConfig.text(0.027),
                    color: appColors.primaryToPrimaryDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _remainingLabel(ManagedStudyPlanEntity plan) {
    if (plan.startsInDays > 0) {
      return 'تبدأ بعد ${plan.startsInDays} يوم';
    }

    if (plan.remainingDays <= 0) {
      return 'انتهت الخطة';
    }

    if (plan.remainingDays == 1) {
      return 'متبقي يوم واحد';
    }

    return 'متبقي ${plan.remainingDays} يوم';
  }
}

class _PlanInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PlanInfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.009),
      ),
      decoration: BoxDecoration(
        color: appColors.primaryToPrimaryDark.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            icon,
            size: SizeConfig.text(0.038),
            color: appColors.primaryToPrimaryDark,
          ),

          SizedBox(width: SizeConfig.w(0.015)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  fontSize: SizeConfig.text(0.024),
                  color: AppPalette.greyMedium,
                ),
                CustomTextWidget(
                  value,
                  fontSize: SizeConfig.text(0.027),
                  color: appColors.blackToGrey2Dark,
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
