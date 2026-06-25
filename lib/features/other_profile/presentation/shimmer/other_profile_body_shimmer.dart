import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class OtherProfileBodyShimmer extends StatelessWidget {
  const OtherProfileBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.h(0.012)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
            child: const OtherProfileHeaderCardShimmer(),
          ),

          SizedBox(height: SizeConfig.h(0.018)),

          const OtherProfileTabsSectionShimmer(),

          SizedBox(height: SizeConfig.h(0.018)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
            child: const OtherProfileOverviewTabShimmer(),
          ),

          SizedBox(height: SizeConfig.h(0.03)),
        ],
      ),
    );
  }
}

class OtherProfileHeaderCardShimmer extends StatelessWidget {
  const OtherProfileHeaderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.h(0.16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: AppShimmerBox(
                    width: double.infinity,
                    height: SizeConfig.h(0.16),
                    borderRadius: 14,
                  ),
                ),
                Positioned(
                  right: SizeConfig.w(0.04),
                  bottom: -SizeConfig.w(0.095),
                  child: AppShimmerBox(
                    width: SizeConfig.w(0.19),
                    height: SizeConfig.w(0.19),
                    borderRadius: 100,
                  ),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: Offset(-SizeConfig.w(0.25), SizeConfig.h(0.005)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.42),
                  height: SizeConfig.h(0.024),
                  borderRadius: 8,
                ),

                SizedBox(height: SizeConfig.h(0.012)),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    _SmallStatShimmer(width: SizeConfig.w(0.14)),
                    SizedBox(width: SizeConfig.w(0.025)),
                    _SmallStatShimmer(width: SizeConfig.w(0.14)),
                    SizedBox(width: SizeConfig.w(0.025)),
                    _SmallStatShimmer(width: SizeConfig.w(0.14)),
                  ],
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                AppShimmerBox(
                  width: SizeConfig.w(0.22),
                  height: SizeConfig.h(0.035),
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

class _SmallStatShimmer extends StatelessWidget {
  final double width;

  const _SmallStatShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(
      width: width,
      height: SizeConfig.h(0.018),
      borderRadius: 6,
    );
  }
}

class OtherProfileTabsSectionShimmer extends StatelessWidget {
  const OtherProfileTabsSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (_) => AppShimmerBox(
            width: SizeConfig.w(0.19),
            height: SizeConfig.h(0.038),
            borderRadius: 18,
          ),
        ),
      ),
    );
  }
}
class OtherProfileOverviewTabShimmer extends StatelessWidget {
  const OtherProfileOverviewTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _BasicInfoSectionShimmer(),

        CustomDivider(height: 30, thickness: 3),

        const _RatingSummarySectionShimmer(),

        CustomDivider(height: 30, thickness: 3),

        const _GeneralStatsSectionShimmer(),
      ],
    );
  }
}

class _BasicInfoSectionShimmer extends StatelessWidget {
  const _BasicInfoSectionShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBackgroundWithChild(
              backgroundColor:
                  isDark ? AppPalette.greyLightDark : AppPalette.greyLight,
              borderRadius: BorderRadius.circular(5),
              childHorizontalPad: SizeConfig.w(0.02),
              childVerticalPad: SizeConfig.h(0.004),
              child: AppShimmerBox(
                width: SizeConfig.w(0.26),
                height: SizeConfig.h(0.016),
                borderRadius: 6,
              ),
            ),
            AppShimmerBox(
              width: SizeConfig.w(0.25),
              height: SizeConfig.h(0.022),
              borderRadius: 7,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          textDirection: TextDirection.rtl,
          children: const [
            Expanded(child: _BasicInfoItemShimmer()),
            _VerticalInfoDividerShimmer(),
            Expanded(child: _BasicInfoItemShimmer()),
            _VerticalInfoDividerShimmer(),
            Expanded(child: _BasicInfoItemShimmer()),
            _VerticalInfoDividerShimmer(),
            Expanded(child: _BasicInfoItemShimmer()),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.02)),

        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            textDirection: TextDirection.rtl,
            spacing: SizeConfig.w(0.02),
            runSpacing: SizeConfig.h(0.012),
            children: [
              _ChipShimmer(width: SizeConfig.w(0.20)),
              _ChipShimmer(width: SizeConfig.w(0.25)),
              _ChipShimmer(width: SizeConfig.w(0.18)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BasicInfoItemShimmer extends StatelessWidget {
  const _BasicInfoItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppShimmerBox(
          width: SizeConfig.w(0.065),
          height: SizeConfig.w(0.065),
          borderRadius: 12,
        ),
        const SizedBox(height: 3),
        AppShimmerBox(
          width: SizeConfig.w(0.12),
          height: SizeConfig.h(0.015),
          borderRadius: 6,
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        AppShimmerBox(
          width: SizeConfig.w(0.13),
          height: SizeConfig.h(0.015),
          borderRadius: 6,
        ),
      ],
    );
  }
}

class _RatingSummarySectionShimmer extends StatelessWidget {
  const _RatingSummarySectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppShimmerBox(
          width: SizeConfig.w(0.16),
          height: SizeConfig.h(0.022),
          borderRadius: 7,
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppShimmerBox(
                    width: SizeConfig.w(0.22),
                    height: SizeConfig.h(0.04),
                    borderRadius: 8,
                  ),
                  SizedBox(height: SizeConfig.h(0.008)),
                  AppShimmerBox(
                    width: SizeConfig.w(0.32),
                    height: SizeConfig.h(0.016),
                    borderRadius: 6,
                  ),
                  SizedBox(height: SizeConfig.h(0.015)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (_) => Padding(
                        padding: EdgeInsets.only(left: SizeConfig.w(0.01)),
                        child: AppShimmerBox(
                          width: SizeConfig.w(0.045),
                          height: SizeConfig.w(0.045),
                          borderRadius: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.06)),

            Expanded(
              flex: 4,
              child: Column(
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.007)),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        AppShimmerBox(
                          width: SizeConfig.w(0.11),
                          height: SizeConfig.h(0.015),
                          borderRadius: 6,
                        ),
                        SizedBox(width: SizeConfig.w(0.018)),
                        Expanded(
                          child: AppShimmerBox(
                            width: double.infinity,
                            height: 6,
                            borderRadius: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GeneralStatsSectionShimmer extends StatelessWidget {
  const _GeneralStatsSectionShimmer();

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

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          children: [
            const Expanded(child: _StatCardShimmer()),
            SizedBox(width: SizeConfig.w(0.02)),
            const Expanded(child: _StatCardShimmer()),
            SizedBox(width: SizeConfig.w(0.02)),
            const Expanded(child: _StatCardShimmer()),
          ],
        ),
      ],
    );
  }
}

class _StatCardShimmer extends StatelessWidget {
  const _StatCardShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.w(0.02),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: isDark ? AppPalette.greyLightDark : AppPalette.greyLight,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              AppShimmerBox(
                width: SizeConfig.h(0.034),
                height: SizeConfig.h(0.034),
                borderRadius: 4,
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              AppShimmerBox(
                width: SizeConfig.w(0.10),
                height: SizeConfig.h(0.022),
                borderRadius: 7,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(0.008)),
          AppShimmerBox(
            width: SizeConfig.w(0.18),
            height: SizeConfig.h(0.013),
            borderRadius: 6,
          ),
        ],
      ),
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

class _ChipShimmer extends StatelessWidget {
  final double width;

  const _ChipShimmer({required this.width});

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