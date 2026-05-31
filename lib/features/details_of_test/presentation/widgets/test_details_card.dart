import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestDetailsCard extends StatelessWidget {
  final String title;
  final String description;
  final String difficultyLevel;
  final double price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;
  final bool hasLiked;
  final bool hasBookmarked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikeValueTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onBookmarkValueTap;

  const TestDetailsCard({
    super.key,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
    required this.hasLiked,
    required this.hasBookmarked,
    this.onLikeTap,
    this.onLikeValueTap,
    this.onBookmarkTap,
    this.onBookmarkValueTap,
  });

  Color _difficultyColor(String difficulty) {
    switch (difficulty.trim()) {
      case 'سهل':
        return AppPalette.green;
      case 'متوسط':
        return AppPalette.orange;
      case 'صعب':
        return AppPalette.red;
      default:
        return AppPalette.primary;
    }
  }

  String _formatPrice(double price) {
    if (price <= 0) return 'مجاني';

    if (price % 1 == 0) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final difficultyColor = _difficultyColor(difficultyLevel);
    final priceText = _formatPrice(price);
    final isFree = price <= 0;

    return CustomBackgroundWithChild(
      width: double.infinity,
      childHorizontalPad: SizeConfig.w(0.022),
      childVerticalPad: SizeConfig.h(0.012),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: appColors.greyMediumTogrey,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      border: Border.all(color: appColors.greyToGreyMediumDark, width: 2),
      backgroundColor: appColors.greyToGreyMediumDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: SizeConfig.w(0.14),
            child: Column(
              children: [
                CustomBackgroundWithChild(
                  backgroundColor: difficultyColor,
                  childHorizontalPad: SizeConfig.w(0.02),
                  childVerticalPad: 2,
                  borderRadius: BorderRadius.circular(5),
                  child: CustomTextWidget(
                    difficultyLevel,
                    fontSize: SizeConfig.text(0.027),
                    color: AppPalette.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Spacer(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomTextWidget(
                        priceText,
                        fontSize: SizeConfig.text(isFree ? 0.04 : 0.055),
                        color: appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                if (!isFree)
                  CustomTextWidget(
                    "ليرة سورية",
                    fontSize: SizeConfig.text(0.028),
                    color: AppPalette.greyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DashedVerticalDivider(
              height: SizeConfig.h(0.14),
              color: AppPalette.greyMedium,
              width: 2,
              dashGap: 2,
              dashHeight: SizeConfig.h(0.015),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: CustomTextWidget(
                        title,
                        fontSize: SizeConfig.text(0.046),
                        color: appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriBold,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),

                CustomTextWidget(
                  description,
                  fontSize: SizeConfig.text(0.028),
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),

                SizedBox(height: SizeConfig.h(0.01)),

                
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class DashedVerticalDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashGap;
  final double width;

  const DashedVerticalDivider({
    super.key,
    required this.height,
    required this.color,
    this.dashHeight = 6,
    this.dashGap = 4,
    this.width = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final dashCount = (height / (dashHeight + dashGap)).floor();

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (_) {
          return Container(
            width: width,
            height: dashHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(width),
            ),
          );
        }),
      ),
    );
  }
}
