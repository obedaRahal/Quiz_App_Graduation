import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tap/test_overview_tap.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tap/sample_test_tap.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_purchase_bottom_bar.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';

class DetailsOfTestView extends StatelessWidget {
  const DetailsOfTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageHeader(
              title: 'تفاصيل اختبار',
              onBack: () {
                context.pop();
              },
              onShare: () {
                debugPrint('share');
              },
            ),

            SizedBox(height: SizeConfig.h(0.015)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TestDetailsWithPlayModesSection(),

                    SizedBox(height: SizeConfig.h(0.035)),

                    const DetailsOfTestTabsSection(),

                    SizedBox(height: SizeConfig.h(0.02)),
                  ],
                ),
              ),
            ),

            const TestPurchaseBottomBar(),
          ],
        ),
      ),
    );
  }
}

class DetailsOfTestTabsSection extends StatefulWidget {
  const DetailsOfTestTabsSection({super.key});

  @override
  State<DetailsOfTestTabsSection> createState() =>
      _DetailsOfTestTabsSectionState();
}

class _DetailsOfTestTabsSectionState extends State<DetailsOfTestTabsSection> {
  int selectedIndex = 0;

  final List<String> tabs = const [
    'نظرة عامة',
    'عينة من الاختبار',
    'المراجعات',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Divider(
                  height: 3,
                  thickness: 3,
                  color: AppPalette.greyLight,
                ),
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedIndex == index;
                    final selected = tabs[index];

                    return SizedBox(
                      //width: SizeConfig.w(0.2), // يثبت عرض كل تاب
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() => selectedIndex = index);
                          debugPrint(selected);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextWidget(
                              tabs[index],
                              color: isSelected
                                  ? AppPalette.black
                                  : AppPalette.greyMedium,
                              fontFamily: isSelected
                                  ? AppFont.elMessiriSemiBold
                                  : AppFont.elMessiriRegular,
                              fontSize: SizeConfig.text(0.032),
                            ),

                            SizedBox(height: SizeConfig.h(0.006)),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              height: 3.5,
                              width: isSelected
                                  ? isSelected == 1
                                        ? SizeConfig.w(0.21)
                                        : SizeConfig.w(0.14)
                                  : 0,
                              decoration: BoxDecoration(
                                color: AppPalette.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.025)),

          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return const TestOverviewTab();
      case 1:
        return const SampleTestTab();
      case 2:
        return const _TemporaryTabContent(title: 'محتوى المراجعات');
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TemporaryTabContent extends StatelessWidget {
  final String title;

  const _TemporaryTabContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.25),
      child: Center(
        child: CustomTextWidget(
          title,
          color: AppPalette.greyMedium,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.04),
        ),
      ),
    );
  }
}
