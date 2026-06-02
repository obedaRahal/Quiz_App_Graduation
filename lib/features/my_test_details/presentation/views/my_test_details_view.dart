import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_details_tabs_section.dart';

class MyTestDetailsView extends StatelessWidget {
  final int testId;
  const MyTestDetailsView({super.key, required this.testId});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock Data
    final testData = {
      "title": "اختبار خاص تجريبي",
      "description": "هذا الاختبار غير حقيقي وهو بهدف التجريب فقط",
      "difficultyLevel": "متوسط",
      "price": 0,
      "likesCount": 12,
      "reviewsCount": 5,
      "bookmarksCount": 0,
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageHeader(
              title: testData["title"]!.toString(),
              onBack: () => Navigator.pop(context),
              icon: Icons.info_outline_rounded,
              onIconTap: () {},
            ),
            SizedBox(height: SizeConfig.h(0.015)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.h(0.015)),
                    // Test Details Section
                    TestDetailsWithPlayModesSection(
                      title: testData["title"]!.toString(),
                      description: testData["description"]!.toString(),
                      difficultyLevel: testData["difficultyLevel"]!.toString(),
                      price: 30,
                      likesCount: 12,
                      hasLiked: false,
                      hasBookmarked: false,
                      reviewsCount: 23,
                      bookmarksCount: 34,
                      onMcqModeTap: () {},
                      onChallengeModeTap: () {},
                      onFlashCardModeTap: () {},
                    ),

                    SizedBox(height: SizeConfig.h(0.03)),

                    // Tabs Section
                    MyTestDetailsTabsSection(testId: testId),
                  ],
                ),
              ),
            ),

            CustomBackgroundWithChild(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.03),
                vertical: SizeConfig.h(0.017),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppPalette.greyMediumDark
                      : AppPalette.greyBorderCart,
                  blurRadius: 4,
                  offset: const Offset(0, -4),
                ),
              ],
              backgroundColor: appColors.whiteToblack,
              child: Row(
                children: [
                  CustomButtonWidget(
                    backgroundColor: appColors.primaryToPrimaryDark,
                    childHorizontalPad: SizeConfig.w(0.04),
                    childVerticalPad: SizeConfig.w(0.013),
                    borderRadius: 20,
                    onTap: () {},
                    child: Row(
                      children: [
                        CustomTextWidget(
                          "تحميل الاختبار",
                          fontSize: SizeConfig.text(0.025),
                          color: appColors.whiteToblack,
                        ),

                        Icon(
                          Icons.download,
                          size: SizeConfig.h(0.02),
                          color: appColors.whiteToblack,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.02)),

                  CustomButtonWidget(
                    backgroundColor: appColors.greyToGreyMediumDark,
                    childHorizontalPad: SizeConfig.w(0.04),
                    childVerticalPad: SizeConfig.w(0.013),
                    borderRadius: 20,
                    onTap: () {},
                    child: Row(
                      children: [
                        CustomTextWidget(
                          "مشاركة الاختبار",
                          fontSize: SizeConfig.text(0.025),
                          color: AppPalette.greyMedium,
                        ),
                        Icon(
                          Icons.share,
                          size: SizeConfig.h(0.02),
                          color: AppPalette.greyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
