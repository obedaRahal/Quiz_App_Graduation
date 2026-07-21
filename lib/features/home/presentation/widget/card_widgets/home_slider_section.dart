import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'home_slider_card.dart';

class HomeSliderSection extends StatelessWidget {
  final PageController controller2;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;
  final HomeState state;

  const HomeSliderSection({
    super.key,
    required this.controller2,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = SizeConfig.textScaleFactor.clamp(1.0, 1.25);
    final cardHeight = (SizeConfig.w(0.80) * textScale)
        .clamp(285.0, 360.0)
        .toDouble();

    if (state.isRecommendedTestsLoading) {
      return SizedBox(
        height: cardHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.recommendedTestsError != null) {
      return SizedBox(
        height: SizeConfig.h(0.20),
        child: Center(
          child: CustomTextWidget(
            'حدث خطأ أثناء جلب الاختبارات',
            color: AppPalette.greyMedium,
          ),
        ),
      );
    }

    if (state.recommendedTests.isEmpty) {
      return SizedBox(
        height: SizeConfig.h(0.20),
        child: Center(
          child: CustomTextWidget(
            'لا توجد اختبارات حالياً',
            color: AppPalette.greyMedium,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.02),
        vertical: SizeConfig.h(0.01).clamp(6.0, 10.0).toDouble(),
      ),
      child: SizedBox(
        height: cardHeight,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView.builder(
            controller: controller2,
            padEnds: false,
            itemCount: state.recommendedTests.length,
            itemBuilder: (context, index) {
              final item = state.recommendedTests[index];

              return HomeSliderCard(
                item: item,
                isDark: isDark,
                appColors: appColors,
                colorScheme: colorScheme,
                onViewTap: () {
                  debugPrint(
                    "go to other test and test id is : ${item.test.id}",
                  );
                  context.pushNamed(
                    AppRouterName.detailsOfTest,
                    extra: DetailsOfTestRouteArgs(testId: item.test.id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
