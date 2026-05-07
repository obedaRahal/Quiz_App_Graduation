import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
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
  final VoidCallback? onBookmarkTap;

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
    this.onBookmarkTap,
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
    final difficultyColor = _difficultyColor(difficultyLevel);
    final priceText = _formatPrice(price);
    final isFree = price <= 0;

    return CustomBackgroundWithChild(
      width: double.infinity,
      childHorizontalPad: SizeConfig.w(0.022),
      childVerticalPad: SizeConfig.h(0.012),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: AppPalette.greyMedium,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      border: Border.all(color: AppPalette.greyLight, width: 2),
      backgroundColor: AppPalette.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: SizeConfig.w(0.14),
            child: Column(
              children: [
                CustomBackgroundWithChild(
                  backgroundColor: difficultyColor,
                  childHorizontalPad: SizeConfig.w(0.03),
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
                        color: AppPalette.black,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    children: [
                      CustomTextWidget(
                        title,
                        fontSize: SizeConfig.text(0.046),
                        color: AppPalette.black,
                        fontFamily: AppFont.elMessiriBold,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     _TestInfoCounter(
                //       value: bookmarksCount.toString(),
                //       icon: FontAwesomeIcons.bookmark,
                //     ),
                //     SizedBox(width: SizeConfig.w(0.025)),
                //     _TestInfoCounter(
                //       value: reviewsCount.toString(),
                //       icon: FontAwesomeIcons.comment,
                //     ),
                //     SizedBox(width: SizeConfig.w(0.025)),
                //     _TestInfoCounter(
                //       value: likesCount.toString(),
                //       icon: FontAwesomeIcons.heart,
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TestInfoCounter(
                      value: bookmarksCount.toString(),
                      icon: FontAwesomeIcons.bookmark,
                      isActive: hasBookmarked,
                      activeColor: AppPalette.primary,
                      onTap: onBookmarkTap,
                    ),
                    SizedBox(width: SizeConfig.w(0.025)),

                    _TestInfoCounter(
                      value: reviewsCount.toString(),
                      icon: FontAwesomeIcons.comment,
                    ),
                    SizedBox(width: SizeConfig.w(0.025)),

                    _TestInfoCounter(
                      value: likesCount.toString(),
                      icon: FontAwesomeIcons.heart,
                      isActive: hasLiked,
                      activeColor: AppPalette.red,
                      onTap: onLikeTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _TestInfoCounter extends StatelessWidget {
//   final String value;
//   final FaIconData icon;

//   const _TestInfoCounter({required this.value, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Row(
//         children: [
//           CustomTextWidget(
//             value,
//             fontSize: SizeConfig.text(0.035),
//             color: AppPalette.greyMedium,
//             fontFamily: AppFont.elMessiriBold,
//           ),
//           SizedBox(width: SizeConfig.w(0.01)),

//           FaIcon(icon, size: SizeConfig.h(0.022), color: AppPalette.greyMedium),
//         ],
//       ),
//     );
//   }
// }

class _TestInfoCounter extends StatelessWidget {
  final String value;
  final FaIconData icon;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  const _TestInfoCounter({
    required this.value,
    required this.icon,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? activeColor ?? AppPalette.primary
        : AppPalette.greyMedium;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.006),
          vertical: SizeConfig.h(0.004),
        ),
        child: Row(
          children: [
            CustomTextWidget(
              value,
              fontSize: SizeConfig.text(0.035),
              color: color,
              fontFamily: AppFont.elMessiriBold,
            ),
            SizedBox(width: SizeConfig.w(0.01)),
            FaIcon(icon, size: SizeConfig.h(0.022), color: color),
          ],
        ),
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
