import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyTaskFailureBody extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const StudyTaskFailureBody({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          SizeConfig.w(0.06),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: SizeConfig.h(0.08),
              color: AppPalette.red,
            ),
            SizedBox(height: SizeConfig.h(0.018)),
            CustomTextWidget(
              title,
              textAlign: TextAlign.center,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.042),
              color: context.appColors.blackToGrey2Dark,
            ),
            SizedBox(height: SizeConfig.h(0.01)),
            CustomTextWidget(
              message,
              textAlign: TextAlign.center,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.032),
              color: AppPalette.greyMedium,
            ),
            SizedBox(height: SizeConfig.h(0.022)),
            CustomButtonWidget(
              onTap: onRetry,
              backgroundColor:
                  context.appColors.primaryToPrimaryDark,
              borderRadius: 6,
              childHorizontalPad: SizeConfig.w(0.06),
              childVerticalPad: SizeConfig.h(0.012),
              child: CustomTextWidget(
                'إعادة المحاولة',
                color: AppPalette.white,
                fontFamily: AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.032),
              ),
            ),
          ],
        ),
      ),
    );
  }
}