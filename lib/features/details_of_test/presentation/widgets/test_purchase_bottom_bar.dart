import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_status_badge.dart';

class TestPurchaseBottomBar extends StatelessWidget {
  final String reviewStatus;
  final bool isFree;
  final bool hasPurchased;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;

  const TestPurchaseBottomBar({
    super.key,
    required this.reviewStatus,
    required this.isFree,
    required this.hasPurchased,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
  });

  bool get _showBuyButton => canPurchase && !isFree && !hasPurchased;

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
          if (_showBuyButton)
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
            )
          else
            Row(
              children: [
                CustomButtonWidget(
                  backgroundColor: AppPalette.primary,
                  childHorizontalPad: SizeConfig.w(0.04),
                  childVerticalPad: SizeConfig.w(0.013),
                  borderRadius: 20,
                  onTap: canDownload
                      ? () => debugPrint("download test")
                      : () {},
                  child: Row(
                    children: [
                      CustomTextWidget(
                        "تحميل الاختبار",
                        fontSize: SizeConfig.text(0.025),
                        color: AppPalette.white,
                      ),

                       Icon(
                        Icons.download,
                        size: SizeConfig.h(0.02),
                        color: AppPalette.white,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: SizeConfig.w(0.02)),

                CustomButtonWidget(
                  backgroundColor: AppPalette.grey,
                  childHorizontalPad: SizeConfig.w(0.04),
                  childVerticalPad: SizeConfig.w(0.013),
                  borderRadius: 20,
                  onTap: canReport ? () => debugPrint("report test") : () {},
                  child: Row(
                    children: [
                      CustomTextWidget(
                        "تقديم إبلاغ",
                        fontSize: SizeConfig.text(0.025),
                        color: AppPalette.greyMedium,
                      ),
                      Icon(
                        Icons.flag_outlined,
                        size: SizeConfig.h(0.02),
                        color: AppPalette.greyMedium,
                      ),
                    ],
                  ),
                ),
              ],
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
              TestStatusBadge(
                title: reviewStatus,
                backgroundColor: AppPalette.greenSoft,
                foregroundColor: AppPalette.green,
                icon: FontAwesomeIcons.solidSquareCheck,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
