import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';

class ManagedStudyPlansEmptyState
    extends StatelessWidget {
  final StudyPlansTab selectedTab;
  final bool isSearchEmptyResult;

  const ManagedStudyPlansEmptyState({
    super.key,
    required this.selectedTab,
    this.isSearchEmptyResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.06),
        vertical: SizeConfig.h(0.05),
      ),
      decoration: BoxDecoration(
        color: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appColors
              .borderFieldColorNLightToborderFieldColorNDark,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isSearchEmptyResult
                ? Icons.search_off_rounded
                : Icons.event_note_rounded,
            size: SizeConfig.text(0.13),
            color: AppPalette.greyMedium,
          ),

          SizedBox(height: SizeConfig.h(0.015)),

          CustomTextWidget(
            isSearchEmptyResult
                ? 'لا توجد نتائج مطابقة'
                : _emptyTitle(),
            fontSize: SizeConfig.text(0.036),
            fontWeight: FontWeight.w700,
            color: appColors.blackToGrey2Dark,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          CustomTextWidget(
            isSearchEmptyResult
                ? 'جرّب البحث باستخدام عنوان مختلف'
                : _emptyDescription(),
            fontSize: SizeConfig.text(0.029),
            color: AppPalette.greyMedium,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  String _emptyTitle() {
    switch (selectedTab) {
      case StudyPlansTab.current:
        return 'لا توجد خطط حالية';

      case StudyPlansTab.expired:
        return 'لا توجد خطط منتهية';

      case StudyPlansTab.future:
        return 'لا توجد خطط مستقبلية';
    }
  }

  String _emptyDescription() {
    switch (selectedTab) {
      case StudyPlansTab.current:
        return 'لا توجد لديك خطة دراسية تعمل عليها حاليًا';

      case StudyPlansTab.expired:
        return 'لم تنتهِ أي خطة دراسية بعد';

      case StudyPlansTab.future:
        return 'لا توجد لديك خطة تبدأ في وقت لاحق';
    }
  }
}