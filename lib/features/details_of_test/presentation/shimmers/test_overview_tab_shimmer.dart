import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestOverviewTabShimmer extends StatelessWidget {
  const TestOverviewTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _TestPublisherCardShimmer(),
      
          CustomDivider(height: 30, thickness: 3),
      
          const _TestInfoDetailsSectionShimmer(),
        ],
      ),
    );
  }
}

class _TestPublisherCardShimmer extends StatelessWidget {
  const _TestPublisherCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppShimmerBox(
          width: SizeConfig.w(0.18),
          height: SizeConfig.h(0.022),
          borderRadius: 7,
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            AppShimmerBox(
              width: SizeConfig.w(0.145),
              height: SizeConfig.h(0.08),
              borderRadius: 10,
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppShimmerBox(
                    width: SizeConfig.w(0.38),
                    height: SizeConfig.h(0.022),
                    borderRadius: 7,
                  ),

                  SizedBox(height: SizeConfig.h(0.012)),

                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppShimmerBox(
                        width: SizeConfig.w(0.13),
                        height: SizeConfig.h(0.017),
                        borderRadius: 6,
                      ),
                      SizedBox(width: SizeConfig.w(0.025)),
                      AppShimmerBox(
                        width: SizeConfig.w(0.13),
                        height: SizeConfig.h(0.017),
                        borderRadius: 6,
                      ),
                      SizedBox(width: SizeConfig.w(0.025)),
                      AppShimmerBox(
                        width: SizeConfig.w(0.13),
                        height: SizeConfig.h(0.017),
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            AppShimmerBox(
              width: SizeConfig.w(0.18),
              height: SizeConfig.h(0.036),
              borderRadius: 6,
            ),
          ],
        ),
      ],
    );
  }
}

class _TestInfoDetailsSectionShimmer extends StatelessWidget {
  const _TestInfoDetailsSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppShimmerBox(
          width: SizeConfig.w(0.28),
          height: SizeConfig.h(0.022),
          borderRadius: 7,
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Expanded(child: _TestInfoItemShimmer()),
            const _VerticalInfoDividerShimmer(),
            const Expanded(child: _TestInfoItemShimmer()),
            const _VerticalInfoDividerShimmer(),
            const Expanded(child: _TestInfoItemShimmer()),
            const _VerticalInfoDividerShimmer(),
            const Expanded(child: _TestInfoItemShimmer()),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.025)),

        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            textDirection: TextDirection.rtl,
            alignment: WrapAlignment.start,
            spacing: SizeConfig.w(0.02),
            runSpacing: SizeConfig.h(0.012),
            children: [
              _InterestChipShimmer(width: SizeConfig.w(0.20)),
              _InterestChipShimmer(width: SizeConfig.w(0.24)),
              _InterestChipShimmer(width: SizeConfig.w(0.18)),
              _InterestChipShimmer(width: SizeConfig.w(0.28)),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.025)),

        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: SizeConfig.h(0.015),
          children: const [
            _MetaInfoItemShimmer(),
            _MetaInfoItemShimmer(),
            _MetaInfoItemShimmer(),
            _MetaInfoItemShimmer(),
          ],
        ),
      ],
    );
  }
}

class _TestInfoItemShimmer extends StatelessWidget {
  const _TestInfoItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppShimmerBox(
          width: SizeConfig.w(0.065),
          height: SizeConfig.w(0.065),
          borderRadius: 12,
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        AppShimmerBox(
          width: SizeConfig.w(0.14),
          height: SizeConfig.h(0.015),
          borderRadius: 6,
        ),

        SizedBox(height: SizeConfig.h(0.004)),

        AppShimmerBox(
          width: SizeConfig.w(0.11),
          height: SizeConfig.h(0.015),
          borderRadius: 6,
        ),
      ],
    );
  }
}

class _VerticalInfoDividerShimmer extends StatelessWidget {
  const _VerticalInfoDividerShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.h(0.065),
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppPalette.greyLight,
    );
  }
}

class _InterestChipShimmer extends StatelessWidget {
  final double width;

  const _InterestChipShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      backgroundColor: appColors.primarySoftTogreyLightDark,
      borderRadius: BorderRadius.circular(20),
      childHorizontalPad: SizeConfig.w(0.025),
      childVerticalPad: SizeConfig.h(0.008),
      child: AppShimmerBox(
        width: width,
        height: SizeConfig.h(0.016),
        borderRadius: 7,
      ),
    );
  }
}

class _MetaInfoItemShimmer extends StatelessWidget {
  const _MetaInfoItemShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      width: SizeConfig.w(0.42),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBackgroundWithChild(
            backgroundColor: appColors.primarySoftTogreyLightDark,
            childHorizontalPad: SizeConfig.w(0.02),
            childVerticalPad: SizeConfig.h(0.01),
            borderRadius: BorderRadius.circular(15),
            child: AppShimmerBox(
              width: SizeConfig.h(0.025),
              height: SizeConfig.h(0.025),
              borderRadius: 10,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.015)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.20),
                  height: SizeConfig.h(0.014),
                  borderRadius: 6,
                ),

                SizedBox(height: SizeConfig.h(0.006)),

                AppShimmerBox(
                  width: SizeConfig.w(0.15),
                  height: SizeConfig.h(0.014),
                  borderRadius: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}