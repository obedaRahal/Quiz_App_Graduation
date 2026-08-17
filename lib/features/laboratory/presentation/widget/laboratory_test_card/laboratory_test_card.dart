import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_footer.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_long_press_menu.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_tags.dart';

import 'laboratory_test_card_header.dart';
import 'laboratory_test_card_stats.dart';

class LaboratoryTestCard extends StatelessWidget {
  final LabRecommendedFeaturedTestEntity item;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const LaboratoryTestCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final test = item.test;

    final cardBorderRadius = SizeConfig.w(0.022).clamp(8.0, 14.0);
    final horizontalMargin = SizeConfig.w(0.015);
    final verticalMargin = SizeConfig.h(0.01);

    final horizontalContentPadding = SizeConfig.w(0.02);
    final descriptionHorizontalPadding = SizeConfig.w(0.015);
    final descriptionVerticalPadding = SizeConfig.h(0.01);

    return GestureDetector(
      onLongPress: () {
        showLaboratoryTestCardLongPressMenu(
          context: context,
          isDark: isDark,
          item: item,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.01)),
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(
            width: SizeConfig.w(0.0025).clamp(1.0, 1.5),
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isDark ? const Color(0xFF484848) : const Color(0xFFD9D9D9))
                      .withOpacity(0.30),
              offset: Offset(0, SizeConfig.h(0.004).clamp(3.0, 6.0)),
              blurRadius: SizeConfig.w(0.035).clamp(10.0, 18.0),
              spreadRadius: -SizeConfig.w(0.0025).clamp(1.0, 2.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LaboratoryTestCardHeader(isDark: isDark, item: item),

            Divider(
              height: SizeConfig.h(0.012),
              thickness: SizeConfig.h(0.0015).clamp(1.0, 1.5),
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalContentPadding,
              ),
              child: CustomTextWidget(
                test.title,
                textAlign: TextAlign.right,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.text(0.05).clamp(12.0, 15.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: descriptionHorizontalPadding,
                vertical: descriptionVerticalPadding,
              ),
              child: CustomTextWidget(
                test.description,
                fontSize: SizeConfig.text(0.034).clamp(11.0, 14.0),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: AppPalette.greyMedium,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.003)),
              child: LaboratoryTestCardTags(
                isDark: isDark,
                tags: test.interestNames,
              ),
            ),

            SizedBox(height: SizeConfig.h(0.005)),

            LaboratoryTestCardStats(isDark: isDark, test: test),

            SizedBox(height: SizeConfig.h(0.003)),

            Divider(
              height: SizeConfig.h(0.012),
              thickness: SizeConfig.h(0.0015).clamp(1.0, 1.5),
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
            ),

            LaboratoryTestCardFooter(
              isDark: isDark,
              appColors: appColors,
              colorScheme: colorScheme,
              price: test.price,
            ),
          ],
        ),
      ),
    );
  }
}
