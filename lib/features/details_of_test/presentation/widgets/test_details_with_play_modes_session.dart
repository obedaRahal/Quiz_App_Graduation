import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/play_mode_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';

class TestDetailsWithPlayModesSection extends StatelessWidget {
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
  final void Function() onMcqModeTap;
  final void Function() onChallengeModeTap;
  final void Function() onFlashCardModeTap;

  const TestDetailsWithPlayModesSection({
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

    required this.onMcqModeTap,
    required this.onChallengeModeTap,
    required this.onFlashCardModeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final detailsHeight = SizeConfig.h(0.24);
    final playCardHeight = SizeConfig.h(0.195);
    final overlapSpace = SizeConfig.h(0.115);

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
                child: TestDetailsCard(
                  title: title,
                  description: description,
                  difficultyLevel: difficultyLevel,
                  price: price,
                  likesCount: likesCount,
                  reviewsCount: reviewsCount,
                  bookmarksCount: bookmarksCount,
                  hasLiked: hasLiked,
                  hasBookmarked: hasBookmarked,
                  onLikeTap: onLikeTap,
                  onLikeValueTap: onLikeValueTap,
                  onBookmarkTap: onBookmarkTap,
                  onBookmarkValueTap: onBookmarkValueTap,
                ),
              ),
            ),

            Positioned(
              top: detailsHeight - overlapSpace,
              left: SizeConfig.w(0.25),
              right: SizeConfig.w(0.02),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _TestInfoCounter(
                        value: bookmarksCount.toString(),
                        icon: hasBookmarked
                            ? FontAwesomeIcons.solidBookmark
                            : FontAwesomeIcons.bookmark,
                        isActive: hasBookmarked,
                        activeColor: hasBookmarked
                            ? AppPalette.black
                            : AppPalette.greyMedium,
                        onIconTap: onBookmarkTap,
                        onValueTap: onBookmarkValueTap,
                      ),
                      SizedBox(width: SizeConfig.w(0.025)),

                      _TestInfoCounter(
                        value: reviewsCount.toString(),
                        icon: FontAwesomeIcons.comment,
                      ),
                      SizedBox(width: SizeConfig.w(0.025)),

                      //                    Icon(Icons.heart),
                      _TestInfoCounter(
                        value: likesCount.toString(),
                        icon: hasLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        isActive: hasLiked,
                        activeColor: AppPalette.red,
                        onIconTap: onLikeTap,
                        onValueTap: onLikeValueTap,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PlayModeCard(
                        title: "التحدي 1VS1",
                        iconPath: AppImage.muscleIcon,
                        backgroundColor: AppPalette.violetMedium,
                        shadowColor: isDark
                            ? AppPalette.black
                            : AppPalette.circleContainer3,
                        onTap: onChallengeModeTap,
                      ),
                      PlayModeCard(
                        title: "اختيارات متعددة",
                        iconPath: "assets/icons/layers.svg",
                        backgroundColor: AppPalette.homeContainer3,
                        shadowColor: isDark
                            ? AppPalette.black
                            : AppPalette.circleContainer3,
                        onTap: onMcqModeTap,
                      ),
                      PlayModeCard(
                        title: "بطاقات الاستذكار",
                        iconPath: "assets/icons/layers.svg",
                        backgroundColor: AppPalette.homeContainer2,
                        shadowColor: isDark
                            ? AppPalette.black
                            : AppPalette.circleContainer1,
                        onTap: onFlashCardModeTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestInfoCounter extends StatelessWidget {
  final String value;
  final FaIconData icon;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onIconTap;
  final VoidCallback? onValueTap;

  const _TestInfoCounter({
    required this.value,
    required this.icon,
    this.isActive = false,
    this.activeColor,
    this.onIconTap,
    this.onValueTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final color = isActive
        ? activeColor ?? appColors.primaryToPrimaryDark
        : AppPalette.greyMedium;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.006),
        vertical: SizeConfig.h(0.004),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onValueTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.006),
                vertical: SizeConfig.h(0.004),
              ),
              child: CustomTextWidget(
                value,
                fontSize: SizeConfig.text(0.035),
                color: color,
                fontFamily: AppFont.elMessiriBold,
              ),
            ),
          ),
          SizedBox(width: SizeConfig.w(0.01)),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onIconTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.006),
                vertical: SizeConfig.h(0.004),
              ),
              child: FaIcon(icon, size: SizeConfig.h(0.022), color: color),
            ),
          ),
        ],
      ),
    );
  }
}
