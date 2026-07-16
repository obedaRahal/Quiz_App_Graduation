import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_selected_test_entity.dart';

class SelectedFolderTestCard extends StatelessWidget {
  final MyProfileFolderSelectedTestEntity test;
  final VoidCallback onRemoveTap;

  const SelectedFolderTestCard({
    super.key,
    required this.test,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.zero,
      border: Border.all(
        color: isDark
            ? AppPalette.borderFieldColorNDark
            : AppPalette.greyBorderCart,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? const Color(0xFF484848) : const Color(0xFFD9D9D9))
              .withOpacity(0.30),
          offset: const Offset(0, 4),
          blurRadius: 14,
          spreadRadius: -1,
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: SizeConfig.h(0.01)),

            CustomTextWidget(
              test.title,
              textAlign: TextAlign.right,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.03),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: appColors.blackToGrey2Dark,
            ),

            SizedBox(height: SizeConfig.h(0.006)),

            CustomTextWidget(
              test.description,
              textAlign: TextAlign.right,
              fontSize: SizeConfig.text(0.024),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: AppPalette.greyMedium,
            ),

            SizedBox(height: SizeConfig.h(0.008)),

            _TagsRow(tags: test.interests),

            SizedBox(height: SizeConfig.h(0.008)),

            _StatsRow(test: test),

            CustomDivider(height: SizeConfig.h(0.013), thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  test.price == 0 ? 'مجاني' : test.price.toStringAsFixed(0),
                  color: appColors.blackToGrey2Dark,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.026),
                ),
                CustomButtonWidget(
                  backgroundColor: context.appColors.primaryToPrimaryDark,
                  borderRadius: 6,
                  childHorizontalPad: SizeConfig.w(0.03),
                  childVerticalPad: SizeConfig.h(0.004),
                  onTap: onRemoveTap,
                  child: CustomTextWidget(
                    'حذف',
                    color: AppPalette.white,
                    fontSize: SizeConfig.text(0.026),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> tags;

  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.028),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: tags.length,
        separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.012)),
        itemBuilder: (context, index) {
          return CustomBackgroundWithChild(
            backgroundColor: context.appColors.primarySoftTogreyLightDark,
            borderRadius: BorderRadius.circular(5),
            childHorizontalPad: SizeConfig.w(0.018),
            childVerticalPad: SizeConfig.h(0.002),
            child: CustomTextWidget(
              '# ${tags[index]}',
              color: context.appColors.primaryToPrimaryDark,
              fontSize: SizeConfig.text(0.021),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final MyProfileFolderSelectedTestEntity test;

  const _StatsRow({required this.test});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SmallStat(title: 'المستوى', value: test.difficultyLevel),
        _SmallStat(title: 'الأسئلة', value: test.questionCount.toString()),
        Column(
          children: [
            CustomTextWidget(
              'التقييم',
              fontSize: SizeConfig.text(0.021),
              color: context.appColors.blackToGrey2Dark,
            ),
            Row(
              children: [
                Icon(Icons.star_rounded, color: AppPalette.yellow, size: 14),
                SizedBox(width: SizeConfig.w(0.005)),
                CustomTextWidget(
                  test.averageRating.toStringAsFixed(1),
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.022),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String title;
  final String value;

  const _SmallStat({required this.title, required this.value});

  Color _valueColor() {
    switch (value.trim()) {
      case 'سهل':
        return AppPalette.green;
      case 'متوسط':
        return AppPalette.orange;
      case 'صعب':
        return AppPalette.red;
      default:
        return AppPalette.greyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.021),
          color: context.appColors.blackToGrey2Dark,
        ),
        CustomTextWidget(
          value,
          fontSize: SizeConfig.text(0.022),
          fontFamily: AppFont.elMessiriBold,
          color: _valueColor(),
        ),
      ],
    );
  }
}
