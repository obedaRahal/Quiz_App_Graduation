import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestDetailsCard extends StatelessWidget {
  const TestDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      width: double.infinity,
      childHorizontalPad: SizeConfig.w(0.022),
      childVerticalPad: SizeConfig.h(0.012),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: AppPalette.greyMedium,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      border: Border.all(color: AppPalette.greyLight, width: 2),
      backgroundColor: AppPalette.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: SizeConfig.w(0.14),
            child: Column(
              children: [
                CustomBackgroundWithChild(
                  backgroundColor: AppPalette.red,
                  childHorizontalPad: SizeConfig.w(0.03),
                  childVerticalPad: 2,
                  borderRadius: BorderRadius.circular(5),
                  child: CustomTextWidget(
                    "صعب",
                    fontSize: SizeConfig.text(0.027),
                    color: AppPalette.white,
                  ),
                ),

                const Spacer(),

                CustomTextWidget(
                  "120",
                  fontSize: SizeConfig.text(0.055),
                  color: AppPalette.black,
                  fontFamily: AppFont.elMessiriBold,
                ),
                CustomTextWidget(
                  "ليرة سورية",
                  fontSize: SizeConfig.text(0.028),
                  color: AppPalette.greyMedium,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DashedVerticalDivider(
              height: SizeConfig.h(0.14),
              color: AppPalette.greyLight,
              width: 2,
              dashGap: 2,
              dashHeight: SizeConfig.h(0.015),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  "جلسة امتحانية اولى",
                  fontSize: SizeConfig.text(0.046),
                  color: AppPalette.black,
                  fontFamily: AppFont.elMessiriBold,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                //SizedBox(height: SizeConfig.h(0.006)),
                CustomTextWidget(
                  "هذه الأسئلة مخصصة للامتحان ونيل أعلى الدرجات بسهولة مطلقة مع شرح مبسط ومراجعة قوية قبل الاختبار",
                  fontSize: SizeConfig.text(0.028),
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.end,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                ),

                SizedBox(height: SizeConfig.h(0.01)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TestInfoCounter(
                      value: "65",
                      icon: FontAwesomeIcons.bookmark,
                    ),
                    SizedBox(width: SizeConfig.w(0.025)),
                    _TestInfoCounter(
                      value: "12",
                      icon: FontAwesomeIcons.comment,
                    ),
                    SizedBox(width: SizeConfig.w(0.025)),
                    _TestInfoCounter(value: "65", icon: FontAwesomeIcons.heart),
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

class _TestInfoCounter extends StatelessWidget {
  final String value;
  final FaIconData icon;

  const _TestInfoCounter({required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          CustomTextWidget(
            value,
            fontSize: SizeConfig.text(0.035),
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriBold,
          ),
          SizedBox(width: SizeConfig.w(0.01)),

          FaIcon(icon, size: SizeConfig.h(0.022), color: AppPalette.greyMedium),
        ],
      ),
    );
  }
}

class DashedVerticalDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashGap;
  final double width;

  const DashedVerticalDivider({
    super.key,
    required this.height,
    required this.color,
    this.dashHeight = 6,
    this.dashGap = 4,
    this.width = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final dashCount = (height / (dashHeight + dashGap)).floor();

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (_) {
          return Container(
            width: width,
            height: dashHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(width),
            ),
          );
        }),
      ),
    );
  }
}
