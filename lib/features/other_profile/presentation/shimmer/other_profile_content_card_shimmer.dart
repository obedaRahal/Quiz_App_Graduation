import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:shimmer/shimmer.dart';

class ContentCardsShimmerList extends StatelessWidget {
  final int itemCount;
  final double horizonalPadding;

  const ContentCardsShimmerList({
    super.key,
    this.itemCount = 3,
    this.horizonalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: horizonalPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.006)),
      itemBuilder: (_, __) {
        return const OtherProfileContentCardShimmer();
      },
    );
  }
}

class OtherProfileContentCardShimmer extends StatelessWidget {
  const OtherProfileContentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? AppPalette.greyLightDark : AppPalette.greyLight;

    final highlightColor = isDark
        ? AppPalette.greyMediumDark
        : AppPalette.white;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(0),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.012)),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(
                width: SizeConfig.w(0.17),
                height: SizeConfig.w(0.17),
                borderRadius: 10,
              ),

              SizedBox(width: SizeConfig.w(0.025)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ShimmerHeaderRow(),

                    SizedBox(height: SizeConfig.h(0.006)),

                    _ShimmerBox(
                      width: double.infinity,
                      height: SizeConfig.h(0.012),
                      borderRadius: 5,
                    ),

                    SizedBox(height: SizeConfig.h(0.005)),

                    _ShimmerBox(
                      width: SizeConfig.w(0.42),
                      height: SizeConfig.h(0.012),
                      borderRadius: 5,
                    ),

                    SizedBox(height: SizeConfig.h(0.011)),

                    const _ShimmerFooterRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerHeaderRow extends StatelessWidget {
  const _ShimmerHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _ShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.018),
            borderRadius: 5,
          ),
        ),

        SizedBox(width: SizeConfig.w(0.015)),

        _ShimmerBox(
          width: SizeConfig.w(0.11),
          height: SizeConfig.h(0.026),
          borderRadius: 4,
        ),

        SizedBox(width: SizeConfig.w(0.02)),

        _ShimmerBox(
          width: SizeConfig.w(0.075),
          height: SizeConfig.w(0.075),
          borderRadius: 5,
        ),
      ],
    );
  }
}

class _ShimmerFooterRow extends StatelessWidget {
  const _ShimmerFooterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _ShimmerBox(
                width: SizeConfig.w(0.13),
                height: SizeConfig.h(0.025),
                borderRadius: 5,
              ),

              SizedBox(width: SizeConfig.w(0.01)),

              _ShimmerBox(
                width: SizeConfig.w(0.1),
                height: SizeConfig.h(0.025),
                borderRadius: 5,
              ),
            ],
          ),
        ),

        SizedBox(width: SizeConfig.w(0.012)),

        _ShimmerBox(
          width: SizeConfig.w(0.085),
          height: SizeConfig.h(0.022),
          borderRadius: 5,
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        _ShimmerBox(
          width: SizeConfig.w(0.14),
          height: SizeConfig.h(0.022),
          borderRadius: 5,
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppPalette.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
