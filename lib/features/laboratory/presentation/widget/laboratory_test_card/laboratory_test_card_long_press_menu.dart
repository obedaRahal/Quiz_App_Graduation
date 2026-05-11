import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';

void showLaboratoryTestCardLongPressMenu({
  required BuildContext context,
  required bool isDark,
  required LabRecommendedFeaturedTestEntity item,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'إغلاق سبب التوصية',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.18),
                ),
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.92,
                  end: 1.0,
                ).animate(curvedAnimation),
                child: LaboratoryTestRecommendationMenu(
                  isDark: isDark,
                  item: item,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class LaboratoryTestRecommendationMenu extends StatelessWidget {
  final bool isDark;
  final LabRecommendedFeaturedTestEntity item;

  const LaboratoryTestRecommendationMenu({
    super.key,
    required this.isDark,
    required this.item,
  });

  String _bucketText(String bucket) {
    switch (bucket) {
      case 'interest_match':
        return 'مطابق لاهتماماتك';
      case 'target_level_match':
        return 'مطابق لمستواك';
      case 'broad':
        return 'اقتراح عام';
      default:
        return 'توصية مخصصة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = item.recommendation;
    final breakdown = recommendation.scoreBreakdown;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: SizeConfig.w(0.86),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.045),
          vertical: SizeConfig.h(0.022),
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RecommendationHeader(
                isDark: isDark,
                score: recommendation.score,
              ),
              SizedBox(height: SizeConfig.h(0.018)),
              _ReasonSummaryCard(
                isDark: isDark,
                bucketText: _bucketText(recommendation.candidateBucket),
                matchedInterestsCount: recommendation.matchedInterestsCount,
                matchedByTargetLevel: recommendation.matchedByTargetLevel,
              ),
              SizedBox(height: SizeConfig.h(0.018)),
              _BreakdownSection(
                isDark: isDark,
                items: [
                  _BreakdownItemData(
                    title: 'تطابق الاهتمامات',
                    value: breakdown.interestScore,
                    totalScore: recommendation.score,
                    icon: Icons.interests_rounded,
                    color: const Color(0xFF5A7BFF),
                  ),
                  _BreakdownItemData(
                    title: 'تطابق المستوى',
                    value: breakdown.targetLevelScore,
                    totalScore: recommendation.score,
                    icon: Icons.school_rounded,
                    color: const Color(0xFF7D73E8),
                  ),
                  _BreakdownItemData(
                    title: 'تفاعل الطلاب',
                    value: breakdown.participantsScore,
                    totalScore: recommendation.score,
                    icon: Icons.groups_rounded,
                    color: const Color(0xFF34A853),
                  ),
                  _BreakdownItemData(
                    title: 'الإعجابات',
                    value: breakdown.likesScore,
                    totalScore: recommendation.score,
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFFF5A7A),
                  ),
                  _BreakdownItemData(
                    title: 'التقييم',
                    value: breakdown.ratingScore,
                    totalScore: recommendation.score,
                    icon: Icons.star_rounded,
                    color: const Color(0xFFFFB020),
                  ),
                  _BreakdownItemData(
                    title: 'حداثة الاختبار',
                    value: breakdown.freshnessScore,
                    totalScore: recommendation.score,
                    icon: Icons.update_rounded,
                    color: const Color(0xFF00A7B5),
                  ),
                  _BreakdownItemData(
                    title: 'قوة نوع المطابقة',
                    value: breakdown.bucketScore,
                    totalScore: recommendation.score,
                    icon: Icons.verified_rounded,
                    color: const Color(0xFFE056FD),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.014)),
              _CloseButton(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  final bool isDark;
  final List<_BreakdownItemData> items;

  const _BreakdownSection({required this.isDark, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
              child: _BreakdownProgressItem(isDark: isDark, data: item),
            ),
          )
          .toList(),
    );
  }
}

class _BreakdownItemData {
  final String title;
  final double value;
  final double totalScore;
  final IconData icon;
  final Color color;

  const _BreakdownItemData({
    required this.title,
    required this.value,
    required this.totalScore,
    required this.icon,
    required this.color,
  });
}

class _BreakdownProgressItem extends StatelessWidget {
  final bool isDark;
  final _BreakdownItemData data;

  const _BreakdownProgressItem({required this.isDark, required this.data});

  double get percent {
    if (data.totalScore <= 0) return 0;

    final result = data.value / data.totalScore;

    return result.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: SizeConfig.w(0.085),
          height: SizeConfig.w(0.085),
          decoration: BoxDecoration(
            color: data.color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            data.icon,
            color: data.color,
            size: SizeConfig.text(0.047),
          ),
        ),

        SizedBox(width: SizeConfig.w(0.025)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      data.title,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.text(0.031),
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                    ),
                  ),
                  CustomTextWidget(
                    '${data.value.toStringAsFixed(1)} (${(percent * 100).toStringAsFixed(1)}%)',
                    fontSize: SizeConfig.text(0.028),
                    color: AppPalette.greyMedium,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.006)),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: SizeConfig.h(0.007),
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.08)
                      : const Color(0xFFEDEDED),
                  valueColor: AlwaysStoppedAnimation<Color>(data.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonSummaryCard extends StatelessWidget {
  final bool isDark;
  final String bucketText;
  final int matchedInterestsCount;
  final bool matchedByTargetLevel;

  const _ReasonSummaryCard({
    required this.isDark,
    required this.bucketText,
    required this.matchedInterestsCount,
    required this.matchedByTargetLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(0.035)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: SizeConfig.w(0.02),
        runSpacing: SizeConfig.h(0.01),
        children: [
          _ReasonBadge(
            isDark: isDark,
            icon: Icons.interests_rounded,
            text: bucketText,
            color: const Color(0xFF5A7BFF),
          ),
          _ReasonBadge(
            isDark: isDark,
            icon: Icons.link_rounded,
            text: '$matchedInterestsCount اهتمام مشترك',
            color: const Color(0xFF34A853),
          ),
          _ReasonBadge(
            isDark: isDark,
            icon: matchedByTargetLevel
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            text: matchedByTargetLevel
                ? 'مناسب لمستواك'
                : 'قد لا يطابق مستواك تماماً',
            color: matchedByTargetLevel
                ? const Color(0xFF34A853)
                : const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }
}

class _ReasonBadge extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String text;
  final Color color;

  const _ReasonBadge({
    required this.isDark,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.007),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: SizeConfig.text(0.038)),
          SizedBox(width: SizeConfig.w(0.012)),
          CustomTextWidget(
            text,
            fontSize: SizeConfig.text(0.028),
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
          ),
        ],
      ),
    );
  }
}

class _RecommendationHeader extends StatelessWidget {
  final bool isDark;
  final double score;

  const _RecommendationHeader({required this.isDark, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: SizeConfig.w(0.12),
          height: SizeConfig.w(0.12),
          decoration: BoxDecoration(
            color: const Color(0xFF5A7BFF).withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: const Color(0xFF5A7BFF),
            size: SizeConfig.text(0.07),
          ),
        ),
        SizedBox(width: SizeConfig.w(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                'لماذا رشحناه لك؟',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.text(0.045),
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
              ),
              SizedBox(height: SizeConfig.h(0.004)),
              CustomTextWidget(
                'درجة التوصية ${score.toStringAsFixed(2)}',
                fontSize: SizeConfig.text(0.032),
                color: AppPalette.greyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  final bool isDark;

  const _CloseButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.012)),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : const Color(0xFFF2F4F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: CustomTextWidget(
            'حسناً',
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.text(0.034),
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
          ),
        ),
      ),
    );
  }
}
