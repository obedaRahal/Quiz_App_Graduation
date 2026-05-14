import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestDetailsWithPlayModesSectionShimmer extends StatelessWidget {
  const TestDetailsWithPlayModesSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final detailsHeight = SizeConfig.h(0.21);
    final playCardHeight = SizeConfig.h(0.15);
    final overlapSpace = SizeConfig.h(0.04);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: SizedBox(
        height: detailsHeight + playCardHeight - overlapSpace,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: detailsHeight,
                child: const _TestDetailsCardShimmer(),
              ),
            ),

            Positioned(
              top: detailsHeight - overlapSpace,
              left: SizeConfig.w(0.2),
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _PlayModeCardShimmer(),
                  _PlayModeCardShimmer(),
                  _PlayModeCardShimmer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestDetailsCardShimmer extends StatelessWidget {
  const _TestDetailsCardShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: isDark ? AppPalette.black : AppPalette.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: appColors.borderFieldColorNLightToborderFieldColorNDark,
      ),
      childHorizontalPad: SizeConfig.w(0.035),
      childVerticalPad: SizeConfig.h(0.018),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              AppShimmerBox(
                width: SizeConfig.w(0.48),
                height: SizeConfig.h(0.026),
                borderRadius: 8,
              ),
              const Spacer(),
              AppShimmerBox(
                width: SizeConfig.w(0.16),
                height: SizeConfig.h(0.026),
                borderRadius: 14,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          AppShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.018),
            borderRadius: 7,
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          AppShimmerBox(
            width: SizeConfig.w(0.68),
            height: SizeConfig.h(0.018),
            borderRadius: 7,
          ),

          SizedBox(height: SizeConfig.h(0.025)),

          //const Spacer(),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Row(
                textDirection: TextDirection.rtl,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppShimmerBox(
                    width: SizeConfig.w(0.055),
                    height: SizeConfig.w(0.055),
                    borderRadius: 20,
                  ),
                  SizedBox(width: SizeConfig.w(0.012)),
                  AppShimmerBox(
                    width: SizeConfig.w(0.08),
                    height: SizeConfig.h(0.017),
                    borderRadius: 6,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PlayModeCardShimmer extends StatelessWidget {
  const _PlayModeCardShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      width: SizeConfig.w(0.18),
      backgroundColor: isDark
          ? AppPalette.greyMediumDark.withOpacity(0.55)
          : appColors.primarySoftTogreyLightDark,
      borderRadius: BorderRadius.circular(16),
      childHorizontalPad: SizeConfig.w(0.018),
      childVerticalPad: SizeConfig.h(0.012),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppShimmerBox(
            width: SizeConfig.w(0.09),
            height: SizeConfig.w(0.09),
            borderRadius: 14,
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          AppShimmerBox(
            width: SizeConfig.w(0.13),
            height: SizeConfig.h(0.014),
            borderRadius: 6,
          ),

          SizedBox(height: SizeConfig.h(0.005)),

          AppShimmerBox(
            width: SizeConfig.w(0.10),
            height: SizeConfig.h(0.014),
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}
