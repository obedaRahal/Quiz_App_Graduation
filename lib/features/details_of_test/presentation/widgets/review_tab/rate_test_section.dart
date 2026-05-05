import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class RateTestSection extends StatefulWidget {
  const RateTestSection({super.key});

  @override
  State<RateTestSection> createState() => _RateTestSectionState();
}

class _RateTestSectionState extends State<RateTestSection> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  static const int maxChars = 200;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = reviewController.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              "قيم الاختبار",
              color: AppPalette.black,
              fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
            ),

            CustomButtonWidget(
              backgroundColor: AppPalette.primary,
              childHorizontalPad: SizeConfig.w(0.06),
              childVerticalPad: SizeConfig.w(0.01),
              borderRadius: 18,
              onTap: () {
                debugPrint("publish rating: $selectedRating");
                debugPrint("review: ${reviewController.text}");
              },
              child: CustomTextWidget(
                "نشر",
                color: AppPalette.white,
                fontSize: SizeConfig.text(0.03),
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.004)),

        CustomTextWidget(
          "أخبر الآخرين ما هو انطباعك",
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.03),
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = starValue <= selectedRating;

            return GestureDetector(
              onTap: () {
                setState(() => selectedRating = starValue);
              },
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                size: SizeConfig.h(0.072),
                color: isSelected ? AppPalette.yellow : AppPalette.greyMedium,
              ),
            );
          }),
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        SizedBox(
          height: 40,
          child: TextField(
            controller: reviewController,
            maxLength: maxChars,
            maxLines: 2,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: "",
              hintText: "اشرح تجربتك (اختياري)",
              hintStyle: TextStyle(
                color: AppPalette.greyMedium,
                fontFamily: AppFont.elMessiriRegular,
                fontSize: SizeConfig.text(0.032),
              ),
              filled: true,
              fillColor: AppPalette.grey,
              contentPadding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.035),
                vertical: SizeConfig.h(0.012),
              ),
              prefixIcon: Padding(
                padding:  EdgeInsets.all(SizeConfig.h(0.015)),
                child: FaIcon(
                  FontAwesomeIcons.masksTheater,
                  color: AppPalette.greyMedium,
                  size: SizeConfig.h(0.03),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppPalette.borderFieldColorNLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppPalette.borderFieldColorNLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppPalette.primary),
              ),
            ),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.003)),

        Align(
          
          alignment: Alignment.centerLeft,
          child: CustomTextWidget(
            "$maxChars/$currentLength",
            color: currentLength >= maxChars
                ? AppPalette.red
                : AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.028),
          ),
        ),
      ],
    );
  }
}
