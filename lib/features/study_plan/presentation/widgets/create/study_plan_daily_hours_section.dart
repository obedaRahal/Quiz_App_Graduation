import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_edit_small_button.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';

class StudyPlanDailyHoursSection extends StatelessWidget {
  final int dailyHours;
  final VoidCallback onTap;

  const StudyPlanDailyHoursSection({
    super.key,
    required this.dailyHours,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasHours = dailyHours > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StudyPlanFormSectionHeader(
          title: 'ساعات الدراسة اليومية',
          description:
              'حدد الوقت اليومي الذي تستطيع تخصيصه للدراسة حتى يتم توزيع المهام بشكل مناسب.',
          image: AppImage.timer,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: CustomTextWidget(
                hasHours
                    ? _formatHours(dailyHours)
                    : 'لم يتم تحديد الساعات بعد',
                fontSize: SizeConfig.text(0.034),
                fontFamily: AppFont.elMessiriSemiBold,
                color: hasHours
                    ? context.appColors.primaryToPrimaryDark
                    : AppPalette.greyMedium,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Spacer(),
            ProfileEditSmallButton(title: 'تعديل الساعات', onTap: onTap),
          ],
        ),
      ],
    );
  }

  String _formatHours(int hours) {
    if (hours == 1) {
      return 'ساعة واحدة يوميًا';
    }

    if (hours == 2) {
      return 'ساعتان يوميًا';
    }

    return '$hours ساعات يوميًا';
  }
}
