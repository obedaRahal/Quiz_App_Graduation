import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

class SelectableStudySubjectChip extends StatelessWidget {
  final StudySubjectEntity subject;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableStudySubjectChip({
    super.key,
    required this.subject,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final selectedColor =
        context.appColors.primaryToPrimaryDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.006),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.13)
              : isDark
                  ? AppPalette.fieldColorNDark
                  : AppPalette.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
            width: isSelected ? 1.3 : 1,
          ),
        ),
        child: CustomTextWidget(
          subject.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
          color: isSelected
              ? selectedColor
              : context.appColors.blackToGrey2Dark,
        ),
      ),
    );
  }
}