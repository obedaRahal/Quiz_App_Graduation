import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_state.dart';
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
    if (state.isRecommendedTestsLoading) {
      return SizedBox(
        height: SizeConfig.h(0.40),
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
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: SizeConfig.isSmallPhone
            ? SizeConfig.h(0.38)
            : SizeConfig.isMediumPhone
            ? SizeConfig.h(0.40)
            : SizeConfig.h(0.41),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
