import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/card_widgets/test_card_long_press_menu.dart';
import 'home_slider_card_footer.dart';
import 'home_slider_card_header.dart';
import 'home_slider_card_stats.dart';
import 'home_slider_card_tags.dart';

class HomeSliderCard extends StatelessWidget {
  final RecommendedTestItemEntity item;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;
  final VoidCallback onViewTap;

  const HomeSliderCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showTestCardLongPressMenu(context: context, isDark: isDark, item: item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.01)),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isDark ? const Color(0xFF484848) : const Color(0xFFD9D9D9))
                      .withValues(alpha: 0.30),
              offset: const Offset(0, 4),
              blurRadius: 14,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSliderCardHeader(isDark: isDark, owner: item.owner),
            Divider(
              height: SizeConfig.h(0.012).clamp(8.0, 12.0).toDouble(),
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.02)),
              child: CustomTextWidget(
                item.test.title,
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
                horizontal: SizeConfig.w(0.02),
                vertical: SizeConfig.h(0.006).clamp(4.0, 6.0).toDouble(),
              ),
              child: CustomTextWidget(
                item.test.description,
                fontSize: SizeConfig.diagonal * .014,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: AppPalette.greyMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.h(0.003).clamp(2.0, 3.0).toDouble(),
              ),
              child: HomeSliderCardTags(
                isDark: isDark,
                tags: item.test.interestNames,
              ),
            ),
            SizedBox(height: SizeConfig.h(0.005).clamp(3.0, 5.0).toDouble()),
            HomeSliderCardStats(isDark: isDark, test: item.test),
            SizedBox(height: SizeConfig.h(0.003).clamp(2.0, 3.0).toDouble()),
            Divider(
              height: SizeConfig.h(0.012).clamp(8.0, 12.0).toDouble(),
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
            ),
            HomeSliderCardFooter(
              isDark: isDark,
              appColors: appColors,
              colorScheme: colorScheme,
              price: item.test.price,
              onViewTap: onViewTap,
            ),
          ],
        ),
      ),
    );
  }
}
