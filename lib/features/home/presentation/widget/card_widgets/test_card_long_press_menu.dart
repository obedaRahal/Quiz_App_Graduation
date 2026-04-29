import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_tests_response_entity.dart';

void showTestCardLongPressMenu({
  required BuildContext context,
  required bool isDark,
  required RecommendedTestItemEntity item,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'إغلاق قائمة الاختبار',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
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
              onTap: () {
                Navigator.of(context).pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 7,
                  sigmaY: 7,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(
                    isDark ? 0.35 : 0.18,
                  ),
                ),
              ),
            ),

            Center(
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.92,
                  end: 1.0,
                ).animate(curvedAnimation),
                child: TestCardLongPressMenu(
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

class TestCardLongPressMenu extends StatelessWidget {
  final bool isDark;
   final RecommendedTestItemEntity item;

  const TestCardLongPressMenu({
    super.key,
    required this.isDark,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          // مهم جداً:
          // حتى لا يتم إغلاق القائمة عندما يضغط المستخدم داخلها.
        },
        child: Container(
          width: SizeConfig.w(0.82),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.045),
            vertical: SizeConfig.h(0.022),
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1F1F1F)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
              width: 1,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MenuHeader(isDark: isDark),

                SizedBox(height: SizeConfig.h(0.018)),

                _TestInfoSection(isDark: isDark),

                SizedBox(height: SizeConfig.h(0.018)),

                Divider(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.greyBorderCart,
                ),

                _MenuActionItem(
                  isDark: isDark,
                  icon: Icons.visibility_outlined,
                  title: 'معاينة الاختبار',
                  subtitle: 'عرض أسئلة المعاينة قبل البدء',
                  onTap: () {
                    Navigator.of(context).pop();

                    // لاحقاً تضع هنا الانتقال لصفحة المعاينة
                    // context.push(...);
                  },
                ),

                _MenuActionItem(
                  isDark: isDark,
                  icon: Icons.bookmark_border_rounded,
                  title: 'حفظ الاختبار',
                  subtitle: 'إضافة الاختبار إلى المحفوظات',
                  onTap: () {
                    Navigator.of(context).pop();

                    // لاحقاً تستدعي API الحفظ
                  },
                ),

                _MenuActionItem(
                  isDark: isDark,
                  icon: Icons.share_outlined,
                  title: 'مشاركة الاختبار',
                  subtitle: 'مشاركة رابط الاختبار مع الآخرين',
                  onTap: () {
                    Navigator.of(context).pop();

                    // لاحقاً تضيف منطق المشاركة
                  },
                ),

                _MenuActionItem(
                  isDark: isDark,
                  icon: Icons.report_gmailerrorred_outlined,
                  title: 'الإبلاغ عن الاختبار',
                  subtitle: 'إرسال بلاغ في حال وجود مشكلة',
                  isDanger: true,
                  onTap: () {
                    Navigator.of(context).pop();

                    // لاحقاً تفتح BottomSheet الإبلاغ أو صفحة البلاغ
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final bool isDark;

  const _MenuHeader({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: SizeConfig.w(0.11),
          height: SizeConfig.w(0.11),
          decoration: BoxDecoration(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : const Color(0xFFEFF3FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.quiz_outlined,
            color: isDark
                ? AppPalette.textWhiteINDark
                : const Color(0xFF5A7BFF),
            size: SizeConfig.text(0.07),
          ),
        ),

        SizedBox(width: SizeConfig.w(0.03)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                'جلسة امتحانية',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.text(0.045),
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
              ),
              SizedBox(height: SizeConfig.h(0.004)),
              CustomTextWidget(
                'خيارات ومعلومات إضافية عن الاختبار',
                fontSize: SizeConfig.text(0.03),
                color: AppPalette.greyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestInfoSection extends StatelessWidget {
  final bool isDark;

  const _TestInfoSection({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.w(0.035)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            'هذه الأسئلة تساعد على التقدم للامتحان بثقة وذلك في مادة خوارزميات البحث.',
            fontSize: SizeConfig.text(0.032),
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          Row(
            children: [
              _InfoChip(
                isDark: isDark,
                icon: Icons.star_rounded,
                text: '4.5',
              ),
              SizedBox(width: SizeConfig.w(0.025)),
              _InfoChip(
                isDark: isDark,
                icon: Icons.help_outline_rounded,
                text: '50 سؤال',
              ),
              SizedBox(width: SizeConfig.w(0.025)),
              _InfoChip(
                isDark: isDark,
                icon: Icons.payments_outlined,
                text: '180 ل.س',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.isDark,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.006),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.greyBorderCart,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: SizeConfig.text(0.038),
            color: AppPalette.greyMedium,
          ),
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

class _MenuActionItem extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDanger;
  final VoidCallback onTap;

  const _MenuActionItem({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isDanger
        ? const Color(0xFFE84C4F)
        : const Color(0xFF5A7BFF);

    final Color titleColor = isDanger
        ? const Color(0xFFE84C4F)
        : isDark
            ? AppPalette.textWhiteINDark
            : AppPalette.textColorInHome;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.h(0.012),
          horizontal: SizeConfig.w(0.01),
        ),
        child: Row(
          children: [
            Container(
              width: SizeConfig.w(0.095),
              height: SizeConfig.w(0.095),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: SizeConfig.text(0.055),
              ),
            ),

            SizedBox(width: SizeConfig.w(0.03)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    title,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.text(0.034),
                    color: titleColor,
                  ),
                  SizedBox(height: SizeConfig.h(0.004)),
                  CustomTextWidget(
                    subtitle,
                    fontSize: SizeConfig.text(0.027),
                    color: AppPalette.greyMedium,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: SizeConfig.text(0.034),
              color: AppPalette.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}