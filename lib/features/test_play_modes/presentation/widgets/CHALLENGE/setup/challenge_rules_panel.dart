import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ChallengeRulesPanel extends StatelessWidget {
  const ChallengeRulesPanel({super.key});
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToPrimaryDark,
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.all(SizeConfig.w(0.035)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              'قواعد التحدي',
              color: appColors.blackToGrey2Dark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),
            SizedBox(height: SizeConfig.h(0.008)),
            Row(
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'كل إجابة صحيحة لك تحسب نقطة واحدة وكذلك للخصم بنفس الطريقة في حال اجابته بشكل صحيح',
                    color: appColors.greyMediumTogrey,
                    fontFamily: AppFont.elMessiriMedium,
                    fontSize: SizeConfig.text(0.026),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.01)),
                CustomBackgroundWithChild(
                  borderRadius: BorderRadius.circular(20),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.01)),
                  backgroundColor: AppPalette.primarySoft,
                  child: CustomTextWidget(
                    '1',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.04),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.01)),

            Row(
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'الاجابة الخاطئة لا تلغي نقطة وفي حال عدم الاجابة خلال الوقت المحدد لن يتم الحصول على نقاط',
                    color: appColors.greyMediumTogrey,
                    fontFamily: AppFont.elMessiriMedium,
                    fontSize: SizeConfig.text(0.026),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.01)),
                CustomBackgroundWithChild(
                  borderRadius: BorderRadius.circular(20),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.01)),
                  backgroundColor: AppPalette.primarySoft,
                  child: CustomTextWidget(
                    '2',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.04),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
