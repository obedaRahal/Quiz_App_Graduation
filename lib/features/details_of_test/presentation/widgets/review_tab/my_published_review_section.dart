import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';



enum MyReviewAction { edit, delete }

class MyPublishedReviewSection extends StatelessWidget {
  final MyPublishedReviewUiModel review;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyPublishedReviewSection({
    super.key,
    required this.review,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'تقييمك',
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.04),
        ),
        SizedBox(height: SizeConfig.h(0.012)),
        MyPublishedReviewCard(
          review: review,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ],
    );
  }
}



class MyPublishedReviewUiModel {
  final String reviewerName;
  final String? avatarPath;
  final bool isVerified;
  final String publishedAtText;
  final double rating;
  final String reviewText;
  final int helpfulCount;

  const MyPublishedReviewUiModel({
    required this.reviewerName,
    this.avatarPath,
    required this.isVerified,
    required this.publishedAtText,
    required this.rating,
    required this.reviewText,
    required this.helpfulCount,
  });
}