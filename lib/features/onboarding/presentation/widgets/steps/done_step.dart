import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import '../../../../../core/theme/assets/images.dart';
import '../../../../../core/utils/media_query_config.dart';

class OnboardingDoneStep extends StatelessWidget {
  const OnboardingDoneStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      //crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //height: SizeConfig.w(0.65),
        Positioned(
          top: 0,
          right: -12,
          child: SizedBox(
            //width: SizeConfig.w(0.55),
            //height: SizeConfig.h(0.16),
            child: ClipRRect(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topLeft,
                  widthFactor: 0.75,
                  //heightFactor: 0.62,
                  child: CustomAppImage(
                    path: AppImage.onbardingupcheck,
                    fit: BoxFit.cover,
                    scale: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),

        Column(
          children: [
            SizedBox(height: 90),
            Center(
              child: CustomTextWidget(
                'مستعد للانطلاق\nفي تجربة جديدة\nومميزة؟',
                textAlign: TextAlign.center,
                color: AppPalette.black,
                fontSize: SizeConfig.text(0.065),
                fontFamily: AppFont.elMessiriBold,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: SizeConfig.h(0.025)),
            Center(
              child: CustomTextWidget(
                'واجهة تطبيقك جاهزة للاستخدام\nالآن فقط قم بتسجيل الدخول\nواستمتع بالتجربة الفريدة',
                textAlign: TextAlign.center,
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.034),
                fontFamily: AppFont.elMessiriRegular,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Positioned(
          bottom: -120,
          left: -12,
          child: SizedBox(
            //width: SizeConfig.w(0.55),
            //height: SizeConfig.h(0.16),
            child: ClipRRect(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.bottomRight,
                  widthFactor: 0.65,
                  //heightFactor: 1,
                  child: CustomAppImage(
                    path: AppImage.onbardingdowncheck,
                    fit: BoxFit.cover,
                    scale: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
