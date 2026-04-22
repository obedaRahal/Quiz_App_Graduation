import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeSliderCardHeader extends StatelessWidget {
  final bool isDark;

  const HomeSliderCardHeader({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(SizeConfig.w(0.02)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomAppImage(
              height: SizeConfig.w(0.12),
              width: SizeConfig.w(0.12),
              path: AppImage.carmen,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              CustomTextWidget(
                "كريم محمد",
                fontSize: SizeConfig.text(0.04),
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
                fontWeight: FontWeight.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: SizeConfig.h(0.005),
              ),
              Row(
                children: [
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.feather,
                  ),
                  SizedBox(
                    width: SizeConfig.w(0.01),
                  ),
                  Flexible(
                    child: CustomTextWidget(
                      "اختبار 125",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.w(0.02),
                  ),
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.handshake,
                  ),
                  SizedBox(
                    width: SizeConfig.w(0.01),
                  ),
                  Flexible(
                    child: CustomTextWidget(
                      "متابع 255",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}