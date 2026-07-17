import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanDetailsStatCard extends StatelessWidget {
  final String imagePath;
  final int value;
  final String title;

  const StudyPlanDetailsStatCard({
    super.key,
    required this.imagePath,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.018),
        vertical: SizeConfig.h(0.014),
      ),
      decoration: BoxDecoration(
        color: appColors.greyToGreyMediumDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.greyToGreyMediumDark),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              CustomAppImage(
                path: imagePath,
                width: SizeConfig.w(0.075),
                height: SizeConfig.w(0.075),
                fit: BoxFit.contain,
              ),
              SizedBox(width: SizeConfig.w(0.015)),

              Flexible(
                child: CustomTextWidget(
                  '$value',
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.052),
                  color: appColors.blackToGrey2Dark,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          CustomTextWidget(
            title,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.028),
            color: appColors.blackToGrey2Dark,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
