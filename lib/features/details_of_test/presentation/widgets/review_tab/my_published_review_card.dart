import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/display_rating_stars_row.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_section.dart';

class MyPublishedReviewCard extends StatelessWidget {
  final MyPublishedReviewUiModel review;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyPublishedReviewCard({
    super.key,
    required this.review,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppPalette.greyMediumDark : AppPalette.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.018),
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            // boxShadow: [
            //   BoxShadow(
            //     color: shadowColor,
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReviewHeader(
                reviewerName: review.reviewerName,
                avatarPath: review.avatarPath,
                isVerified: review.isVerified,
                publishedAtText: review.publishedAtText,
                rating: review.rating,
                helpfulCount: review.helpfulCount,
              ),
              SizedBox(height: SizeConfig.h(0.006)),

              SizedBox(height: SizeConfig.h(0.012)),
              CustomTextWidget(
                review.reviewText,
                textAlign: TextAlign.right,
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.034),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        Positioned(
          left: -6,
          //right: 0,
          top: 4,
          child: _ReviewMoreButton(onEdit: onEdit, onDelete: onDelete),
        ),
      ],
    );
  }
}

class _ReviewMoreButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReviewMoreButton({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return PopupMenuButton<MyReviewAction>(
      padding: EdgeInsets.zero,
      tooltip: '',
      color: Theme.of(context).cardColor,
      icon: Icon(
        Icons.more_vert_rounded,
        color: appColors.blackTogreyMedium,
        size: SizeConfig.h(0.03),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case MyReviewAction.edit:
            onEdit();
            break;
          case MyReviewAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<MyReviewAction>(
          value: MyReviewAction.edit,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.edit_outlined, size: SizeConfig.h(0.023)),
              SizedBox(width: SizeConfig.w(0.02)),
              CustomTextWidget(
                "تعديل",
                fontSize: SizeConfig.text(0.03),
                color: appColors.blackTogreyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<MyReviewAction>(
          value: MyReviewAction.delete,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: SizeConfig.h(0.023),
                color: AppPalette.red,
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              CustomTextWidget(
                "حذف",
                fontSize: SizeConfig.text(0.03),
                color: appColors.blackTogreyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewerAvatar extends StatelessWidget {
  final String? avatarPath;

  const ReviewerAvatar({super.key, required this.avatarPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: avatarPath == null || avatarPath!.trim().isEmpty
          ? Container(
              width: 48,
              height: 48,
              color: AppPalette.greyLight,
              child: const Icon(Icons.person, size: 24),
            )
          : CustomAppImage(
              path: avatarPath!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _ReviewMetaRow extends StatelessWidget {
  final String dateText;
  final double rating;

  const _ReviewMetaRow({required this.dateText, required this.rating});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DisplayRatingStarsRow(
          rating: rating,
          starSize: SizeConfig.h(0.028),
          horizontalSpacing: 1,
          emptyColor: isDark ? AppPalette.greyMedium : AppPalette.greyLight,
        ),
        SizedBox(width: SizeConfig.w(0.02)),
        CustomTextWidget(
          dateText,
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.029),
        ),
      ],
    );
  }
}

class ReviewHeader extends StatelessWidget {
  final String reviewerName;
  final String? avatarPath;
  final bool isVerified;
  final String publishedAtText;
  final double rating;
  final int? helpfulCount;

  const ReviewHeader({
    super.key,
    required this.reviewerName,
    required this.avatarPath,
    required this.isVerified,
    required this.publishedAtText,
    required this.rating,
    this.helpfulCount,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReviewerAvatar(avatarPath: avatarPath),

        SizedBox(width: SizeConfig.w(0.02)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: CustomTextWidget(
                        reviewerName,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        color: appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriSemiBold,
                        fontSize: SizeConfig.text(0.038),
                        maxLines: 1,
                      ),
                    ),
                  ),

                  if (isVerified) ...[
                    SizedBox(width: SizeConfig.w(0.012)),
                    Icon(
                      Icons.verified_rounded,
                      color: appColors.primaryToPrimaryDark,
                      size: 15,
                    ),
                  ],

                  SizedBox(width: SizeConfig.w(0.02)),

                  if (helpfulCount != null)
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.w(0.055)),
                      child: CustomBackgroundWithChild(
                        backgroundColor: isDark
                            ? AppPalette.primary.withOpacity(0.18)
                            : AppPalette.primarySoft,
                        borderRadius: BorderRadius.circular(5),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.018),
                          vertical: SizeConfig.h(0.004),
                        ),
                        child: CustomTextWidget(
                          '$helpfulCount وجدوها مفيدة',
                          color: appColors.primaryToPrimaryDark,
                          fontFamily: AppFont.elMessiriMedium,
                          fontSize: SizeConfig.text(0.022),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.006)),

              _ReviewMetaRow(dateText: publishedAtText, rating: rating),
            ],
          ),
        ),
      ],
    );
  }
}
