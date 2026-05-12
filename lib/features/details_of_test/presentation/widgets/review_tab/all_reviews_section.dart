import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';

class ReviewsSection extends StatelessWidget {
  final ReviewRatingFilter selectedFilter;
  final ValueChanged<ReviewRatingFilter> onFilterChanged;
  final List<PublicReviewUiModel> reviews;
  final ValueChanged<int> onReportReview;
  final ValueChanged<int> onHelpfulYes;
  final ValueChanged<int> onHelpfulNo;

  final bool canInteractWithReviews;

  final bool isFeedbackLoading;
  final int? activeFeedbackReviewId;

  const ReviewsSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.reviews,
    required this.onReportReview,
    required this.onHelpfulYes,
    required this.onHelpfulNo,

    required this.canInteractWithReviews,

    required this.isFeedbackLoading,
    required this.activeFeedbackReviewId,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'المراجعات',
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.04),
        ),
        SizedBox(height: SizeConfig.h(0.01)),
        ReviewRatingFilterBar(
          selectedFilter: selectedFilter,
          onChanged: onFilterChanged,
        ),
        SizedBox(height: SizeConfig.h(0.02)),
        if (reviews.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.03)),
              child: CustomTextWidget(
                'لا توجد مراجعات مطابقة حاليًا',
                color: appColors.greyMediumTogrey,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(0.018)),
                child: PublicReviewCard(
                  review: review,
                  canInteractWithReview: canInteractWithReviews,
                  isFeedbackLoading:
                      isFeedbackLoading && activeFeedbackReviewId == review.id,
                  onReport: () => onReportReview(review.id),
                  onHelpfulYes: () => onHelpfulYes(review.id),
                  onHelpfulNo: () => onHelpfulNo(review.id),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

enum ReviewRatingFilter {
  all,
  five,
  four,
  three,
  two,
  one;

  String get label {
    switch (this) {
      case ReviewRatingFilter.all:
        return 'الكل';
      case ReviewRatingFilter.five:
        return '5';
      case ReviewRatingFilter.four:
        return '4';
      case ReviewRatingFilter.three:
        return '3';
      case ReviewRatingFilter.two:
        return '2';
      case ReviewRatingFilter.one:
        return '1';
    }
  }

  int? get ratingValue {
    switch (this) {
      case ReviewRatingFilter.all:
        return null;
      case ReviewRatingFilter.five:
        return 5;
      case ReviewRatingFilter.four:
        return 4;
      case ReviewRatingFilter.three:
        return 3;
      case ReviewRatingFilter.two:
        return 2;
      case ReviewRatingFilter.one:
        return 1;
    }
  }
}

class PublicReviewUiModel {
  final int id;
  final String reviewerName;
  final String? avatarPath;
  final bool isVerified;
  final String publishedAtText;
  final double rating;
  final String reviewText;
  final int helpfulCount;

  /// null = لم يجب بعد
  /// true = نعم
  /// false = لا
  final bool? myHelpfulVote;

  const PublicReviewUiModel({
    required this.id,
    required this.reviewerName,
    this.avatarPath,
    required this.isVerified,
    required this.publishedAtText,
    required this.rating,
    required this.reviewText,
    required this.helpfulCount,
    this.myHelpfulVote,
  });

  PublicReviewUiModel copyWith({
    int? id,
    String? reviewerName,
    String? avatarPath,
    bool? isVerified,
    String? publishedAtText,
    double? rating,
    String? reviewText,
    int? helpfulCount,
    bool? myHelpfulVote,
  }) {
    return PublicReviewUiModel(
      id: id ?? this.id,
      reviewerName: reviewerName ?? this.reviewerName,
      avatarPath: avatarPath ?? this.avatarPath,
      isVerified: isVerified ?? this.isVerified,
      publishedAtText: publishedAtText ?? this.publishedAtText,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      myHelpfulVote: myHelpfulVote ?? this.myHelpfulVote,
    );
  }
}

class ReviewRatingFilterBar extends StatelessWidget {
  final ReviewRatingFilter selectedFilter;
  final ValueChanged<ReviewRatingFilter> onChanged;

  const ReviewRatingFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        textDirection: TextDirection.rtl,
        children: ReviewRatingFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;

          return Padding(
            padding: EdgeInsetsDirectional.only(start: SizeConfig.w(0.015)),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(filter),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.035),
                  vertical: SizeConfig.h(0.008),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? appColors.primaryToPrimaryDark
                      : appColors.greyToGreyMediumDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter != ReviewRatingFilter.all) ...[
                      Icon(
                        Icons.star_border_rounded,
                        size: 14,
                        color: isSelected
                            ? appColors.whiteToblack
                            : appColors.blackTogreyMedium,
                      ),
                      SizedBox(width: SizeConfig.w(0.008)),
                    ],
                    CustomTextWidget(
                      filter.label,
                      color: isSelected
                          ? appColors.whiteToblack
                          : appColors.blackTogreyMedium,
                      fontSize: SizeConfig.text(0.028),
                      fontFamily: AppFont.elMessiriSemiBold,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PublicReviewCard extends StatelessWidget {
  final PublicReviewUiModel review;
  final VoidCallback onReport;
  final VoidCallback onHelpfulYes;
  final VoidCallback onHelpfulNo;

  final bool canInteractWithReview;

  final bool isFeedbackLoading;

  const PublicReviewCard({
    super.key,
    required this.review,
    required this.onReport,
    required this.onHelpfulYes,
    required this.onHelpfulNo,

    required this.canInteractWithReview,

    this.isFeedbackLoading = false,
  });

  @override
  Widget build(BuildContext context) {
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

              SizedBox(height: SizeConfig.h(0.015)),
              CustomTextWidget(
                review.reviewText,
                textAlign: TextAlign.right,
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.034),
              ),
              SizedBox(height: SizeConfig.h(0.05)),
            ],
          ),
        ),

        Positioned(
          left: 0,
          //right: 0,
          top: 8,
          child: _ReviewReportMenuButton(onReport: onReport),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.03),
              vertical: SizeConfig.h(0.018),
            ),
            child: _ReviewHelpfulQuestionRow(
              currentVote: review.myHelpfulVote,
              canInteract: canInteractWithReview,
              isLoading: isFeedbackLoading,
              onYesTap: onHelpfulYes,
              onNoTap: onHelpfulNo,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewReportMenuButton extends StatelessWidget {
  final VoidCallback onReport;

  const _ReviewReportMenuButton({required this.onReport});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      tooltip: '',
      color: Theme.of(context).cardColor,
      icon: Icon(
        Icons.more_vert_rounded,
        color: appColors.blackTogreyMedium,
        size: SizeConfig.h(0.03),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (_) => onReport(),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.flag_outlined,
                size: SizeConfig.h(0.023),
                color: Colors.red,
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              CustomTextWidget(
                "إبلاغ عن التعليق",
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

class _ReviewHelpfulQuestionRow extends StatelessWidget {
  final bool? currentVote;
  final bool canInteract;
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;
  final bool isLoading;

  const _ReviewHelpfulQuestionRow({
    required this.currentVote,
    required this.canInteract,
    this.isLoading = false,
    required this.onYesTap,
    required this.onNoTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: CustomTextWidget(
            canInteract
                ? 'هل وجدت هذه المراجعة مفيدة؟'
                : 'اشترِ الاختبار للتفاعل مع المراجعات',
            //'هل وجدت هذه المراجعة مفيدة؟',
            color: appColors.primaryToPrimaryDark,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: SizeConfig.w(0.02)),

        // if (isLoading)
        //   SizedBox(
        //     width: SizeConfig.w(0.045),
        //     height: SizeConfig.w(0.045),
        //     child: CircularProgressIndicator(
        //       strokeWidth: 2,
        //       color: AppPalette.primary,
        //     ),
        //   )
        // else ...[
        //   _HelpfulActionButton(
        //     title: 'نعم',
        //     isSelected: currentVote == true,
        //     onTap: onYesTap,
        //   ),
        //   SizedBox(width: SizeConfig.w(0.02)),
        //   _HelpfulActionButton(
        //     title: 'لا',
        //     isSelected: currentVote == false,
        //     onTap: isLoading ? null : onYesTap,
        //   ),
        // ],
        _HelpfulActionButton(
          title: 'نعم',
          isSelected: currentVote == true,
          onTap: isLoading ? null : onYesTap,
        ),

        SizedBox(width: SizeConfig.w(0.02)),

        _HelpfulActionButton(
          title: 'لا',
          isSelected: currentVote == false,
          onTap: isLoading ? null : onNoTap,
        ),
      ],
    );
  }
}

class _HelpfulActionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const _HelpfulActionButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.008),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.primaryToPrimaryDark.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
        ),
        child: CustomTextWidget(
          title,
          color: isSelected
              ? appColors.primaryToPrimaryDark
              : appColors.blackTogreyMedium,
          fontSize: SizeConfig.text(0.028),
        ),
      ),
    );
  }
}
