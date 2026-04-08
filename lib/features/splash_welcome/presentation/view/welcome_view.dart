import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: WelcomeViewBody()));
  }
}

class WelcomeViewBody extends StatelessWidget {
  const WelcomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          SizedBox(
            //width: double.infinity,
            //height: SizeConfig.h(.66),
            child:CustomAppImage(
                                path:  AppImage.welcome,
              //fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          CustomTextWidget(
            "اختباراتي",
            fontSize: SizeConfig.text(0.07),
            fontFamily: AppFont.elMessiriBold,
            color: AppColor.primary,
          ),

          CustomTextWidget(
            "الدراسة صارت أسهل ! \n كل ما تحتاجه للنجاح الأكاديمي \n أصبح في مكان واحد",
            fontSize: SizeConfig.text(0.045),
          ),

          DownPartWelcome(),
        ],
      ),
    );
  }
}

class DownPartWelcome extends StatelessWidget {
  const DownPartWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(.04),
        vertical: SizeConfig.h(.025),
      ),
      child: CustomBackgroundWithChild(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: double.infinity,
        backgroundColor: AppColor.primary,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.height * .025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButtonWidget(
                    backgroundColor: AppColor.black,
                    childHorizontalPad: SizeConfig.w(.06),
                    childVerticalPad: SizeConfig.h(.012),
                    borderRadius: 30,
                    onTap: () {
                      debugPrint(" loginnnnn");
                      //context.pushNamed(AppRouteRName.registerView);
                    },
                    child: CustomTextWidget(
                      "تسجيل الدخول",
                      fontSize: SizeConfig.text(.038),
                      color: AppColor.white,
                    ),
                  ),
                  CustomButtonWidget(
                    backgroundColor: AppColor.white,
                    childHorizontalPad: SizeConfig.w(.06),
                    childVerticalPad: SizeConfig.h(.012),
                    borderRadius: 30,
                    onTap: () {
                      //context.pushNamed(AppRouteRName.loginView);

                      debugPrint(" regester ");
                    },
                    child: CustomTextWidget(
                      "حساب جديد",
                      fontSize: SizeConfig.text(.038),
                      //color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
