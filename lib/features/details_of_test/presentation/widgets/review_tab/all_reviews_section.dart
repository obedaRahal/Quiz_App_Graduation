import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';

class ReviewsSection extends StatelessWidget {
  final ReviewRatingFilter selectedFilter;
  final ValueChanged<ReviewRatingFilter> onFilterChanged;
  final List<PublicReviewUiModel> reviews;
  final ValueChanged<int> onReportReview;
  final ValueChanged<int> onHelpfulYes;
  final ValueChanged<int> onHelpfulNo;

  const ReviewsSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.reviews,
    required this.onReportReview,
    required this.onHelpfulYes,
    required this.onHelpfulNo,
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
                      ? AppPalette.primary
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
                            ? AppPalette.white
                            : appColors.blackTogreyMedium,
                      ),
                      SizedBox(width: SizeConfig.w(0.008)),
                    ],
                    CustomTextWidget(
                      filter.label,
                      color: isSelected
                          ? AppPalette.white
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

  const PublicReviewCard({
    super.key,
    required this.review,
    required this.onReport,
    required this.onHelpfulYes,
    required this.onHelpfulNo,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewReportMenuButton(onReport: onReport),
              //SizedBox(width: SizeConfig.w(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _PublicReviewerHeader(review: review),

                    SizedBox(height: SizeConfig.h(0.015)),
                    CustomTextWidget(
                      review.reviewText,
                      textAlign: TextAlign.right,
                      color: appColors.greyMediumTogrey,
                      fontSize: SizeConfig.text(0.034),
                    ),
                    SizedBox(height: SizeConfig.h(0.041)),
                  ],
                ),
              ),
            ],
          ),
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
              onYes: onHelpfulYes,
              onNo: onHelpfulNo,
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
                color: AppPalette.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PublicReviewerHeader extends StatelessWidget {
  final PublicReviewUiModel review;

  const _PublicReviewerHeader({required this.review});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ReviewerAvatar(avatarPath: review.avatarPath),
        SizedBox(width: SizeConfig.w(0.02)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 7,
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
                      size: 16,
                    ),
                  ],

                  Spacer(),

                  CustomBackgroundWithChild(
                    backgroundColor: isDark
                        ? AppPalette.primary.withOpacity(0.18)
                        : AppPalette.primarySoft,
                    borderRadius: BorderRadius.circular(5),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.018),
                      vertical: SizeConfig.h(0.004),
                    ),

                    child: CustomTextWidget(
                      '${review.helpfulCount} وجدوها مفيدة',
                      color: AppPalette.primary,
                      fontFamily: AppFont.elMessiriMedium,
                      fontSize: SizeConfig.text(0.022),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.006)),

              _PublicReviewMetaRow(
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
      borderRadius: BorderRadius.circular(12),
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

class _PublicReviewMetaRow extends StatelessWidget {
  final String dateText;
  final double rating;

  const _PublicReviewMetaRow({required this.dateText, required this.rating});

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

class _ReviewHelpfulQuestionRow extends StatelessWidget {
  final bool? currentVote;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const _ReviewHelpfulQuestionRow({
    required this.currentVote,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextWidget(
          'هل وجدت هذه المراجعة مفيدة؟',
          color: AppPalette.primary,
          fontSize: SizeConfig.text(0.03),
          textAlign: TextAlign.right,
        ),
        Spacer(),
        _HelpfulActionButton(
          title: 'نعم',
          isSelected: currentVote == true,
          onTap: onYes,
        ),
        SizedBox(width: SizeConfig.w(0.02)),
        _HelpfulActionButton(
          title: 'لا',
          isSelected: currentVote == false,
          onTap: onNo,
        ),
      ],
    );
  }
}

class _HelpfulActionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

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
              ? AppPalette.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppPalette.primary
                : appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
        ),
        child: CustomTextWidget(
          title,
          color: isSelected ? AppPalette.primary : appColors.blackTogreyMedium,
          fontSize: SizeConfig.text(0.028),
        ),
      ),
    );
  }
}
