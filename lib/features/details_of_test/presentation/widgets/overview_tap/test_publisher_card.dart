import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestPublisherCard extends StatelessWidget {
  const TestPublisherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "الناشر",
          color: AppPalette.black,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            CustomAppImage(
              path: AppImage.carmen,
              width: SizeConfig.w(0.145),
              height: SizeConfig.h(0.08),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Flexible(
                        child: CustomTextWidget(
                          "عبيده الرحال",
                          color: AppPalette.black,
                          fontFamily: AppFont.elMessiriSemiBold,
                          fontSize: SizeConfig.text(0.038),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),

                      SizedBox(width: 5),

                      CustomAppImage(
                        path: AppImage.verifyCheck,
                        width: 13,
                        height: 13,
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.h(0.004)),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: const [
                      _PublisherStat(label: "اختبار", value: "43"),
                      _DotSeparator(),
                      _PublisherStat(label: "يتابع", value: "500"),
                      _DotSeparator(),
                      _PublisherStat(label: "متابع", value: "2k"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            CustomButtonWidget(
              backgroundColor: AppPalette.primary,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.006),
              borderRadius: 6,
              onTap: () => debugPrint("follow"),
              child: CustomTextWidget(
                "متابعة",
                color: AppPalette.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PublisherStat extends StatelessWidget {
  final String label;
  final String value;

  const _PublisherStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        CustomTextWidget(
          value,
          color: AppPalette.black,
          fontSize: SizeConfig.text(0.035),
          fontFamily: AppFont.elMessiriBold,
        ),
        SizedBox(width: 3),
        CustomTextWidget(
          label,
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.032),
        ),
      ],
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      "•",
      color: AppPalette.greyMedium,
      fontSize: SizeConfig.text(0.035),
    );
  }
}
