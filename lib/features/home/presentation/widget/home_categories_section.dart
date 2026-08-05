import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_category_card.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/view/tests_by_interest_page.dart';

class CategoriesSection extends StatelessWidget {
  final HomeState state;

  const CategoriesSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {

    if (state.isRecommendedInterestsLoading) {
      return SizedBox(
        height: SizeConfig.height * 0.10,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.recommendedInterestsError != null) {
      return SizedBox(
        height: SizeConfig.height * 0.10,
        child: Center(
          child: CustomTextWidget(
            'حدث خطأ أثناء جلب التصنيفات',
            color: AppPalette.greyMedium,
          ),
        ),
      );
    }

    if (state.recommendedInterests.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
        child: EmptyActionBox(
          icon: Icons.category_outlined,
          title: 'لا توجد تصنيفات',
          description: 'لا توجد تصنيفات مقترحة لعرضها حالياً',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        SizedBox(
          height: SizeConfig.height * 0.07,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: state.recommendedInterests.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = state.recommendedInterests[index];
              return CategoryCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestsByInterestPage(
                        interestId: item.id,
                        interestName: item.name,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
