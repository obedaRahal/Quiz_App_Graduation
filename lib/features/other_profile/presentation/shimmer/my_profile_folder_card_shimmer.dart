import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:shimmer/shimmer.dart';

class MyProfileFoldersShimmerList extends StatelessWidget {
  final int itemCount;
  final double horizonalPadding;

  const MyProfileFoldersShimmerList({
    super.key,
    this.itemCount = 3,  this.horizonalPadding=0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: horizonalPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) =>
          SizedBox(height: SizeConfig.h(0.012)),
      itemBuilder: (_, __) {
        return const MyProfileFolderCardShimmer();
      },
    );
  }
}

class MyProfileFolderCardShimmer extends StatelessWidget {
  const MyProfileFolderCardShimmer({super.key});

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
        borderRadius: BorderRadius.circular(14),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.012)),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(
                width: SizeConfig.w(0.16),
                height: SizeConfig.w(0.16),
                borderRadius: 14,
              ),

              SizedBox(width: SizeConfig.w(0.03)),

              const Expanded(child: _FolderInfoShimmer()),

              SizedBox(width: SizeConfig.w(0.02)),

              _ShimmerBox(
                width: SizeConfig.w(0.075),
                height: SizeConfig.w(0.075),
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderInfoShimmer extends StatelessWidget {
  const _FolderInfoShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerBox(
          width: SizeConfig.w(0.36),
          height: SizeConfig.h(0.02),
          borderRadius: 5,
        ),

        SizedBox(height: SizeConfig.h(0.009)),

        Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SmallInfoShimmer(width: SizeConfig.w(0.2)),

            SizedBox(width: SizeConfig.w(0.025)),

            _SmallInfoShimmer(width: SizeConfig.w(0.24)),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.011)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            _ShimmerBox(
              width: SizeConfig.w(0.14),
              height: SizeConfig.h(0.026),
              borderRadius: 5,
            ),

            SizedBox(width: SizeConfig.w(0.012)),

            _ShimmerBox(
              width: SizeConfig.w(0.11),
              height: SizeConfig.h(0.026),
              borderRadius: 5,
            ),

            SizedBox(width: SizeConfig.w(0.012)),

            _ShimmerBox(
              width: SizeConfig.w(0.09),
              height: SizeConfig.h(0.026),
              borderRadius: 5,
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallInfoShimmer extends StatelessWidget {
  final double width;

  const _SmallInfoShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        _ShimmerBox(
          width: SizeConfig.w(0.035),
          height: SizeConfig.w(0.035),
          borderRadius: 4,
        ),

        SizedBox(width: SizeConfig.w(0.006)),

        _ShimmerBox(width: width, height: SizeConfig.h(0.014), borderRadius: 5),
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
