import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/models/onboarding_route_args.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
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
    final appColors = context.appColors;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              // ThemedAppImage(
              //   height: SizeConfig.h(0.84),
              //   width: double.infinity,
              //   //scale: 1.5,
              //   //fit: BoxFit.cover,
              //   lightPath: AppImage.welcomeLight,
              //   darkPath: AppImage.welcomeDark,
              //   alignment: Alignment.center,
              // ),
              SizedBox(
                width: double.infinity,
                height: SizeConfig.h(0.75),
                child: ClipRect(
                  child: ThemedAppImage(
                    width: double.infinity,
                    height: SizeConfig.h(0.75),
                    fit: BoxFit.cover,
                    scale: 1,
                    lightPath: AppImage.welcomeLight,
                    darkPath: AppImage.welcomeDark,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: CustomButtonWidget(
                  onTap: () {
                    debugPrint("change mode ");
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  child: ThemedAppImage(
                    darkPath: AppImage.logoDark,
                    lightPath: AppImage.logoLight,
                  ),
                ),
              ),
            ],
          ),

          CustomTextWidget(
            "اختباراتي",
            fontSize: SizeConfig.text(0.065),
            fontFamily: AppFont.elMessiriBold,
            color: appColors.primaryToPrimaryDark,
          ),

          CustomTextWidget(
            "الدراسة صارت أسهل ! \n كل ما تحتاجه للنجاح الأكاديمي \n أصبح في مكان واحد",
            fontSize: SizeConfig.text(0.04),
            color: appColors.blackTogreyMedium,
          ),

          Row(
            children: [
              CustomButtonWidget(
                backgroundColor: appColors.blackToGreyLightDark,
                childHorizontalPad: SizeConfig.w(.06),
                childVerticalPad: SizeConfig.h(.01),
                borderRadius: 30,
                onTap: () {
                  debugPrint("اكمال ال onboarding");

                  context.pushNamed(
                    AppRouterName.onboarding,
                    extra: const OnboardingRouteArgs(
                      email: 'obdrhl@gmail.com',
                      lastCompletedStep: 3,
                    ),
                  );
                },
                child: CustomTextWidget(
                  "اكمال",
                  fontSize: SizeConfig.text(.038),
                  color: Colors.white,
                ),
              ),

              CustomButtonWidget(
                backgroundColor: appColors.blackToGreyLightDark,
                childHorizontalPad: SizeConfig.w(.06),
                childVerticalPad: SizeConfig.h(.01),
                borderRadius: 30,
                onTap: () {
                  debugPrint(" onboardingggggg");
                  //context.pushNamed(AppRouterName.onboarding);
                  context.pushNamed(
                    AppRouterName.onboarding,
                    extra: const OnboardingRouteArgs(
                      email: 'obdrhl@gmail.com',
                      lastCompletedStep: 0,
                    ),
                  );
                  //context.pushNamed(AppRouterName.onboarding);
                },
                child: CustomTextWidget(
                  "onboarding",
                  fontSize: SizeConfig.text(.038),
                  color: Colors.white,
                ),
              ),
            ],
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
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(.04),
        vertical: SizeConfig.h(.016),
      ),
      child: CustomBackgroundWithChild(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: double.infinity,
        backgroundColor: appColors.primaryToGreyMediumDark,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.height * .025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButtonWidget(
                    backgroundColor: appColors.blackToGreyLightDark,
                    childHorizontalPad: SizeConfig.w(.06),
                    childVerticalPad: SizeConfig.h(.01),
                    borderRadius: 30,
                    onTap: () {
                      debugPrint(" loginnnnn");
                      context.pushNamed(AppRouterName.login);
                    },
                    child: CustomTextWidget(
                      "تسجيل الدخول",
                      fontSize: SizeConfig.text(.038),
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  CustomButtonWidget(
                    backgroundColor: appColors.whiteToPrimaryDark,
                    childHorizontalPad: SizeConfig.w(.06),
                    childVerticalPad: SizeConfig.h(.01),
                    borderRadius: 30,
                    onTap: () {
                      context.pushNamed(AppRouterName.register);

                      debugPrint(" regester ");
                    },
                    child: CustomTextWidget(
                      "حساب جديد",
                      fontSize: SizeConfig.text(.038),
                      color: appColors.primaryToGreyMediumDark,
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
