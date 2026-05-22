import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
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

    required this.onMcqModeTap
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final detailsHeight = SizeConfig.h(0.24);
    final playCardHeight = SizeConfig.h(0.15);
    final overlapSpace = SizeConfig.h(0.09);

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
                  onLikeValueTap:onLikeValueTap ,
                  onBookmarkTap: onBookmarkTap,
                  onBookmarkValueTap: onBookmarkValueTap,
                ),
              ),
            ),

            Positioned(
              top: detailsHeight - overlapSpace,
              left: SizeConfig.w(0.25),
              right: SizeConfig.w(0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayModeCard(
                    title: "التحدي 1VS1",
                    iconPath: AppImage.muscleIcon,
                    backgroundColor: AppPalette.violetMedium,
                    shadowColor: isDark
                        ? AppPalette.black
                        : AppPalette.circleContainer3,
                    onTap: () => debugPrint("challenge"),
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
                    onTap: () => debugPrint("flashcards"),
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
