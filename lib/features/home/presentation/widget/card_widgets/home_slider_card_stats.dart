import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeSliderCardStats extends StatelessWidget {
  final bool isDark;

  const HomeSliderCardStats({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                CustomTextWidget(
                  'المستوى',
                  fontSize: SizeConfig.diagonal * .014,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),
                CustomTextWidget(
                  'صعب',
                  fontSize: SizeConfig.diagonal * .014,
                ),
              ],
            ),
          ),
          Container(
            height: 28,
            width: 1.5,
            color: Colors.grey,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                CustomTextWidget(
                  'الأسئلة',
                  fontSize: SizeConfig.diagonal * .014,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),
                CustomTextWidget(
                  '135',
                  fontSize: SizeConfig.diagonal * .014,
                  color: AppPalette.greyMedium,
                ),
              ],
            ),
          ),
          Container(
            height: 28,
            width: 1.5,
            color: Colors.grey,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                CustomTextWidget(
                  'التقييم',
                  fontSize: SizeConfig.diagonal * .014,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),
                Row(
                  children: [
                    CustomTextWidget(
                      '4.5',
                      fontSize: SizeConfig.diagonal * .014,
                      color: AppPalette.greyMedium,
                    ),
                    SizedBox(
                      width: SizeConfig.width * .006,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}