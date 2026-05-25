import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class McqTestSessionShimmer extends StatelessWidget {
  const McqTestSessionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(height: SizeConfig.h(0.018)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: Row(
            children: [
              AppShimmerBox(
                width: SizeConfig.w(0.22),
                height: SizeConfig.h(0.035),
                borderRadius: 20,
              ),
              const Spacer(),
              AppShimmerBox(
                width: SizeConfig.w(0.18),
                height: SizeConfig.h(0.04),
                borderRadius: 10,
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: AppShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.015),
            borderRadius: 20,
          ),
        ),

        SizedBox(height: SizeConfig.h(0.025)),

        Expanded(
          child: CustomBackgroundWithChild(
            backgroundColor: AppPalette.black,
            width: double.infinity,
            alignment: Alignment.topCenter,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isDark
                  ? [
                      const Color.fromARGB(255, 29, 58, 121),
                      const Color.fromARGB(255, 62, 123, 221),
                    ]
                  : [AppPalette.blueDark, AppPalette.blueLight],
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.h(0.025),
                vertical: SizeConfig.h(0.025),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -SizeConfig.h(0.04),
                    left: SizeConfig.w(0.13),
                    right: SizeConfig.w(0.13),
                    child: AppShimmerBox(
                      width: double.infinity,
                      height: SizeConfig.h(0.045),
                      borderRadius: 30,
                    ),
                  ),
                  Positioned(
                    bottom: -SizeConfig.h(0.023),
                    left: SizeConfig.w(0.06),
                    right: SizeConfig.w(0.06),
                    child: AppShimmerBox(
                      width: double.infinity,
                      height: SizeConfig.h(0.045),
                      borderRadius: 30,
                    ),
                  ),
                  CustomBackgroundWithChild(
                    width: double.infinity,
                    backgroundColor: appColors.whiteToblack,
                    borderRadius: BorderRadius.circular(30),
                    padding: EdgeInsetsDirectional.only(
                      start: SizeConfig.w(0.022),
                      end: SizeConfig.w(0.022),
                      top: SizeConfig.h(0.025),
                      bottom: SizeConfig.h(0.04),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppShimmerBox(
                              width: SizeConfig.w(0.18),
                              height: SizeConfig.h(0.025),
                              borderRadius: 20,
                            ),
                            AppShimmerBox(
                              width: SizeConfig.w(0.13),
                              height: SizeConfig.h(0.025),
                              borderRadius: 10,
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        AppShimmerBox(
                          width: double.infinity,
                          height: SizeConfig.h(0.022),
                          borderRadius: 8,
                        ),
                        SizedBox(height: SizeConfig.h(0.012)),
                        AppShimmerBox(
                          width: SizeConfig.w(0.72),
                          height: SizeConfig.h(0.022),
                          borderRadius: 8,
                        ),
                        SizedBox(height: SizeConfig.h(0.012)),
                        AppShimmerBox(
                          width: SizeConfig.w(0.55),
                          height: SizeConfig.h(0.022),
                          borderRadius: 8,
                        ),

                        SizedBox(height: SizeConfig.h(0.024)),

                        AppShimmerBox(
                          width: SizeConfig.w(0.22),
                          height: SizeConfig.h(0.028),
                          borderRadius: 20,
                        ),

                        SizedBox(height: SizeConfig.h(0.014)),

                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.h(0.01),
                            ),
                            child: AppShimmerBox(
                              width: double.infinity,
                              height: SizeConfig.h(0.045),
                              borderRadius: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        CustomBackgroundWithChild(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.03)),
          width: double.infinity,
          backgroundColor: isDark
              ? const Color.fromARGB(255, 29, 58, 121)
              : AppPalette.blueDark,
          child: CustomBackgroundWithChild(
            width: double.infinity,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            backgroundColor: appColors.whiteToblack,
            padding: EdgeInsets.all(SizeConfig.w(0.03)),
            child: AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.055),
              borderRadius: 20,
            ),
          ),
        ),
      ],
    );
  }
}
