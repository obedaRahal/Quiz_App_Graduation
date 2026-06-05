import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interest_chip_item.dart';

class TestInfoDetailsSection extends StatelessWidget {
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  //final String reviewStatus;
  final List<String> interests;

  const TestInfoDetailsSection({
    super.key,
    required this.questionCount,
    this.durationSeconds,
    this.passMarkPercentage,
    required this.publishedAt,
    required this.lastContentUpdatedAt,
    required this.targetLevel,
    required this.language,
    required this.participantsCount,
    //required this.reviewStatus,
    required this.interests,
  });

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return 'غير محدد';

    final minutes = seconds ~/ 60;
    if (minutes < 60) return '$minutes دقيقة';

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) return '$hours ساعة';

    return '$hours ساعة و $remainingMinutes دقيقة';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final categories = interests.isEmpty ? const ['غير مصنف'] : interests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "تفاصيل الاختبار",
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: _TestInfoItem(
                iconPath: AppImage.numberofquestion,
                title: "عدد الأسئلة",
                value: questionCount.toString(),
              ),
            ),
            VerticalInfoDivider(),

            Expanded(
              child: _TestInfoItem(
                iconPath: AppImage.timer,
                title: "المدة",
                value: _formatDuration(durationSeconds),
              ),
            ),
            VerticalInfoDivider(),

            Expanded(
              child: _TestInfoItem(
                iconPath: AppImage.downmark,
                title: "حد النجاح",
                value: passMarkPercentage == null
                    ? 'غير محدد'
                    : '$passMarkPercentage%',
              ),
            ),
            VerticalInfoDivider(),

            Expanded(
              child: _TestInfoItem(
                iconPath: AppImage.timerIcon,
                title: "نشر في",
                value: _safeText(publishedAt),
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.025)),

        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            textDirection: TextDirection.rtl,
            alignment: WrapAlignment.start,
            spacing: SizeConfig.w(0.02),
            runSpacing: SizeConfig.h(0.012),
            children: categories.map((interest) {
              return InterestChipItem(
                label: interest,
                isSelected: false,
                onTap: null,
              );
            }).toList(),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.025)),

        Wrap(
          //textDirection: TextDirection.rtl,
          alignment: WrapAlignment.spaceBetween,
          runSpacing: SizeConfig.h(0.015),
          //spacing: SizeConfig.w(0.0005),
          children: [
            _MetaInfoItem(
              title: "تصنيف دراسي",
              value: _safeText(targetLevel),
              icon: FontAwesomeIcons.bookOpenReader,
            ),
            _MetaInfoItem(
              title: "آخر تعديل",
              value: _safeText(lastContentUpdatedAt),
              icon: FontAwesomeIcons.penToSquare,
            ),

            _MetaInfoItem(
              title: "اللغة",
              value: _safeText(language),
              icon: FontAwesomeIcons.language,
            ),
            _MetaInfoItem(
              title: "المتقدمين",
              value: participantsCount.toString(),
              icon: FontAwesomeIcons.users,
            ),
          ],
        ),
      ],
    );
  }

  String _safeText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'غير محدد' : trimmed;
  }
}

class _MetaInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final FaIconData icon;

  const _MetaInfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      width: SizeConfig.w(0.42),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBackgroundWithChild(
            backgroundColor: appColors.primarySoftTogreyLightDark,
            childHorizontalPad: SizeConfig.w(0.02),
            childVerticalPad: SizeConfig.h(0.01),
            borderRadius: BorderRadius.circular(15),
            child: FaIcon(
              icon,
              size: SizeConfig.h(0.025),
              color: appColors.primaryToPrimaryDark,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.015)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  color: appColors.blackTogreyMedium,
                  fontSize: SizeConfig.text(0.027),
                  fontFamily: AppFont.elMessiriBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomTextWidget(
                  value,
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.027),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestInfoItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _TestInfoItem({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      children: [
        CustomAppImage(
          path: iconPath,
          width: SizeConfig.w(0.065),
          height: SizeConfig.w(0.065),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 3),
        CustomTextWidget(
          title,
          color: appColors.blackToGrey2Dark,
          fontSize: SizeConfig.text(0.03),
          fontFamily: AppFont.elMessiriBold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        CustomTextWidget(
          value,
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.03),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class VerticalInfoDivider extends StatelessWidget {
  const VerticalInfoDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.h(0.065),
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppPalette.greyLight,
    );
  }
}
