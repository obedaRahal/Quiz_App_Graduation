import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ReviewTabShimmer extends StatelessWidget {
  const ReviewTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const TestRatingSummarySectionShimmer(),

        CustomDivider(height: 30, thickness: 3),

        const RateTestSectionShimmer(),

        CustomDivider(height: 30, thickness: 3),

        const ReviewsSectionShimmer(),
      ],
    );
  }
}

class TestRatingSummarySectionShimmer extends StatelessWidget {
  const TestRatingSummarySectionShimmer({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppShimmerBox(
                    width: SizeConfig.w(0.28),
                    height: SizeConfig.h(0.04),
                    borderRadius: 8,
                  ),

                  SizedBox(height: SizeConfig.h(0.01)),

                  AppShimmerBox(
                    width: SizeConfig.w(0.34),
                    height: SizeConfig.h(0.016),
                    borderRadius: 6,
                  ),

                  SizedBox(height: SizeConfig.h(0.016)),

                  Row(
                    textDirection: TextDirection.rtl,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: SizeConfig.w(0.008),
                        ),
                        child: AppShimmerBox(
                          width: SizeConfig.h(0.025),
                          height: SizeConfig.h(0.025),
                          borderRadius: 20,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.06)),

            Expanded(
              flex: 4,
              child: Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.007)),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        AppShimmerBox(
                          width: SizeConfig.w(0.11),
                          height: SizeConfig.h(0.014),
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
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RateTestSectionShimmer extends StatelessWidget {
  const RateTestSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppShimmerBox(
              width: SizeConfig.w(0.24),
              height: SizeConfig.h(0.022),
              borderRadius: 7,
            ),

            AppShimmerBox(
              width: SizeConfig.w(0.18),
              height: SizeConfig.h(0.038),
              borderRadius: 18,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.01)),

        AppShimmerBox(
          width: SizeConfig.w(0.40),
          height: SizeConfig.h(0.016),
          borderRadius: 6,
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return AppShimmerBox(
              width: SizeConfig.h(0.06),
              height: SizeConfig.h(0.06),
              borderRadius: 30,
            );
          }),
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        AppShimmerBox(width: double.infinity, height: 40, borderRadius: 8),

        SizedBox(height: SizeConfig.h(0.008)),

        Align(
          alignment: Alignment.centerLeft,
          child: AppShimmerBox(
            width: SizeConfig.w(0.14),
            height: SizeConfig.h(0.014),
            borderRadius: 6,
          ),
        ),
      ],
    );
  }
}

class ReviewsSectionShimmer extends StatelessWidget {
  final int itemCount;
  final bool isThereHeader;

  const ReviewsSectionShimmer({
    super.key,
    this.itemCount = 3,
    this.isThereHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isThereHeader)
          AppShimmerBox(
            width: SizeConfig.w(0.20),
            height: SizeConfig.h(0.022),
            borderRadius: 7,
          ),
        if (isThereHeader) SizedBox(height: SizeConfig.h(0.012)),
        if (isThereHeader) const ReviewRatingFilterBarShimmer(),

        SizedBox(height: SizeConfig.h(0.02)),

        Column(
          children: List.generate(itemCount, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.018)),
              child: const PublicReviewCardShimmer(),
            );
          }),
        ),
      ],
    );
  }
}

class ReviewRatingFilterBarShimmer extends StatelessWidget {
  const ReviewRatingFilterBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _FilterChipShimmer(width: SizeConfig.w(0.16)),
          _FilterChipShimmer(width: SizeConfig.w(0.13)),
          _FilterChipShimmer(width: SizeConfig.w(0.13)),
          _FilterChipShimmer(width: SizeConfig.w(0.13)),
          _FilterChipShimmer(width: SizeConfig.w(0.13)),
          _FilterChipShimmer(width: SizeConfig.w(0.13)),
        ],
      ),
    );
  }
}

class _FilterChipShimmer extends StatelessWidget {
  final double width;

  const _FilterChipShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: SizeConfig.w(0.015)),
      child: AppShimmerBox(
        width: width,
        height: SizeConfig.h(0.036),
        borderRadius: 18,
      ),
    );
  }
}

class PublicReviewCardShimmer extends StatelessWidget {
  const PublicReviewCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppPalette.greyMediumDark : AppPalette.white;
    final shadowColor = isDark
        ? AppPalette.greyLightDark.withOpacity(0.35)
        : Colors.black.withOpacity(0.08);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.018),
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppShimmerBox(width: 48, height: 48, borderRadius: 10),

              SizedBox(width: SizeConfig.w(0.02)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        AppShimmerBox(
                          width: SizeConfig.w(0.35),
                          height: SizeConfig.h(0.02),
                          borderRadius: 7,
                        ),

                        SizedBox(width: SizeConfig.w(0.02)),

                        AppShimmerBox(
                          width: SizeConfig.w(0.22),
                          height: SizeConfig.h(0.024),
                          borderRadius: 5,
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.h(0.01)),

                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        AppShimmerBox(
                          width: SizeConfig.w(0.24),
                          height: SizeConfig.h(0.016),
                          borderRadius: 6,
                        ),

                        SizedBox(width: SizeConfig.w(0.02)),

                        AppShimmerBox(
                          width: SizeConfig.w(0.18),
                          height: SizeConfig.h(0.016),
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: SizeConfig.w(0.02)),

              AppShimmerBox(
                width: SizeConfig.w(0.05),
                height: SizeConfig.h(0.03),
                borderRadius: 20,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.018)),

          AppShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.018),
            borderRadius: 7,
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          AppShimmerBox(
            width: SizeConfig.w(0.72),
            height: SizeConfig.h(0.018),
            borderRadius: 7,
          ),

          SizedBox(height: SizeConfig.h(0.035)),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.016),
                  borderRadius: 6,
                ),
              ),

              SizedBox(width: SizeConfig.w(0.02)),

              AppShimmerBox(
                width: SizeConfig.w(0.13),
                height: SizeConfig.h(0.034),
                borderRadius: 8,
              ),

              SizedBox(width: SizeConfig.w(0.02)),

              AppShimmerBox(
                width: SizeConfig.w(0.13),
                height: SizeConfig.h(0.034),
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
