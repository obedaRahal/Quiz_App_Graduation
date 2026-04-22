import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'home_slider_card_footer.dart';
import 'home_slider_card_header.dart';
import 'home_slider_card_stats.dart';
import 'home_slider_card_tags.dart';

class HomeSliderCard extends StatelessWidget {
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const HomeSliderCard({
    super.key,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
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
            color: (isDark
                    ? const Color(0xFF484848)
                    : const Color(0xFFD9D9D9))
                .withOpacity(0.30),
            offset: const Offset(0, 4),
            blurRadius: 14,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSliderCardHeader(isDark: isDark),
          Divider(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextWidget(
              "جلسة امتحانية",
              textAlign: TextAlign.right,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.text(0.06),
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: CustomTextWidget(
              "هذه الأسئلة تساعد على التقدم للامتحان بثقة وذلك في مادة خوارزميات البحث",
              fontSize: SizeConfig.diagonal * .016,
              textAlign: TextAlign.right,
              color: AppPalette.greyMedium,
            ),
          ),
          HomeSliderCardTags(isDark: isDark),
          SizedBox(height: SizeConfig.height * .005),
          HomeSliderCardStats(isDark: isDark),
          SizedBox(height: SizeConfig.height * .003),
          Divider(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),
          HomeSliderCardFooter(
            isDark: isDark,
            appColors: appColors,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}