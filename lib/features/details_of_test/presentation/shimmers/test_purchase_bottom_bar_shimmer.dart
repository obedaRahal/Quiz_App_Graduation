import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';

class TestPurchaseBottomBarShimmer extends StatelessWidget {
  const TestPurchaseBottomBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      childVerticalPad: SizeConfig.h(0.01),
      childHorizontalPad: SizeConfig.w(0.03),
      backgroundColor: appColors.whiteToblack,
      width: double.infinity,
      boxShadow: [
        BoxShadow(
          color: isDark ? AppPalette.greyMediumDark : AppPalette.greyBorderCart,
          blurRadius: 4,
          offset: const Offset(0, -4),
        ),
      ],
      child: Row(
        children: [
          AppShimmerBox(
            width: SizeConfig.w(0.28),
            height: SizeConfig.h(0.04),
            borderRadius: 20,
          ),

          SizedBox(width: SizeConfig.w(0.02)),

          AppShimmerBox(
            width: SizeConfig.w(0.24),
            height: SizeConfig.h(0.04),
            borderRadius: 20,
          ),

          const Spacer(),

          DashedVerticalDivider(
            height: SizeConfig.h(0.06),
            dashGap: 2,
            width: 2,
            dashHeight: 6,
            color: AppPalette.greyMedium,
          ),

          SizedBox(width: SizeConfig.w(0.05)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppShimmerBox(
                width: SizeConfig.w(0.20),
                height: SizeConfig.h(0.016),
                borderRadius: 6,
              ),

              SizedBox(height: SizeConfig.h(0.006)),

              AppShimmerBox(
                width: SizeConfig.w(0.24),
                height: SizeConfig.h(0.028),
                borderRadius: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}