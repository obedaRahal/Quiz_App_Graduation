import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
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
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppPalette.greyMediumDark : AppPalette.white;
    final shadowColor = isDark
        ? AppPalette.greyLightDark.withOpacity(0.35)
        : Colors.black.withOpacity(0.08);

    return Stack(
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
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewerHeader(review: review),
              SizedBox(height: SizeConfig.h(0.006)),
          
              SizedBox(height: SizeConfig.h(0.012)),
              CustomTextWidget(
                review.reviewText,
                textAlign: TextAlign.right,
                color: appColors.greyMediumTogrey,
                fontSize: SizeConfig.text(0.034),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        Positioned(
          left: 0,
          //right: 0,
          top: 8,
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
                color: AppPalette.black,
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
                color: AppPalette.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewerHeader extends StatelessWidget {
  final MyPublishedReviewUiModel review;

  const _ReviewerHeader({required this.review});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ReviewerAvatar(avatarPath: review.avatarPath),
        SizedBox(width: SizeConfig.w(0.025)),

        Expanded(
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: CustomTextWidget(
                      review.reviewerName,
                      textAlign: TextAlign.right,
                      color: appColors.blackTogreyMedium,
                      fontFamily: AppFont.elMessiriSemiBold,
                      fontSize: SizeConfig.text(0.038),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (review.isVerified) ...[
                    SizedBox(width: SizeConfig.w(0.012)),
                    Icon(
                      Icons.verified_rounded,
                      color: AppPalette.primary,
                      size: 14,
                    ),
                  ],
                ],
              ),

              _ReviewMetaRow(
                dateText: review.publishedAtText,
                rating: review.rating,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewerAvatar extends StatelessWidget {
  final String? avatarPath;

  const _ReviewerAvatar({required this.avatarPath});

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

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DisplayRatingStarsRow(
          rating: rating,
          starSize: SizeConfig.h(0.028),
          horizontalSpacing: 1,
        ),
        SizedBox(width: SizeConfig.w(0.02)),
        CustomTextWidget(
          dateText,
          color: appColors.greyMediumTogrey,
          fontSize: SizeConfig.text(0.029),
        ),
      ],
    );
  }
}
