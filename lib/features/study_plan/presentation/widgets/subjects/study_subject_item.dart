import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

class StudySubjectItem extends StatelessWidget {
  final StudySubjectEntity subject;
  final bool isDeleting;
  final VoidCallback onDeleteTap;

  const StudySubjectItem({
    super.key,
    required this.subject,
    required this.isDeleting,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.009),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppPalette.fieldColorNDark
            : AppPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: CustomTextWidget(
              subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.033),
              color:
                  context.appColors.blackToGrey2Dark,
              textAlign: TextAlign.right,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.02)),

          InkWell(
            onTap: isDeleting ? null : onDeleteTap,
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: SizeConfig.w(0.07),
              height: SizeConfig.w(0.07),
              child: Center(
                child: isDeleting
                    ? SizedBox(
                        width: SizeConfig.w(0.04),
                        height: SizeConfig.w(0.04),
                        child:
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.close_rounded,
                        color: AppPalette.red,
                        size: SizeConfig.text(0.05),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}