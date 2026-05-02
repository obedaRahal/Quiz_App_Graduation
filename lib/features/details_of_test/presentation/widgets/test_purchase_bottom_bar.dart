import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';

class TestPurchaseBottomBar extends StatelessWidget {
  const TestPurchaseBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      childVerticalPad: SizeConfig.h(0.01),
      childHorizontalPad: SizeConfig.w(0.03),
      backgroundColor: AppPalette.white,
      width: double.infinity,
      boxShadow: [
        BoxShadow(
          color: AppPalette.greyBorderCart,
          blurRadius: 4,
          offset: const Offset(0, -4),
        ),
      ],
      child: Row(
        children: [
          CustomButtonWidget(
            backgroundColor: AppPalette.primary,
            childHorizontalPad: SizeConfig.w(0.09),
            childVerticalPad: SizeConfig.w(0.013),
            borderRadius: 20,
            boxShadow: [BoxShadow(color: AppPalette.primary, blurRadius: 4)],
            onTap: () {
              debugPrint("buy now");
            },
            child: CustomTextWidget(
              "اشتري الان",
              fontSize: SizeConfig.text(0.033),
              color: AppPalette.white,
            ),
          ),

          const Spacer(),

          DashedVerticalDivider(
            height: SizeConfig.h(0.06),
            dashGap: 2,
            width: 2,
            dashHeight: 10,
            color: AppPalette.greyMedium,
          ),

          SizedBox(width: SizeConfig.w(0.05)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                "حالة الاختبار",
                color: AppPalette.black,
                fontSize: SizeConfig.text(0.027),
                fontFamily: AppFont.elMessiriBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              CustomBackgroundWithChild(
                backgroundColor: AppPalette.greenSoft,
                childHorizontalPad: SizeConfig.w(0.02),
                childVerticalPad: SizeConfig.h(0.003),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidSquareCheck,
                      size: SizeConfig.h(0.02),
                      color: AppPalette.green,
                    ),
                    const SizedBox(width: 5),
                    CustomTextWidget(
                      "تم التاكد منه",
                      color: AppPalette.green,
                      fontFamily: AppFont.elMessiriSemiBold,
                      fontSize: SizeConfig.text(0.03),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
