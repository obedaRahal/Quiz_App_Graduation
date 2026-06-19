import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_category_card.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/view/tests_by_interest_page.dart';

class CategoriesSection extends StatelessWidget {
  final HomeState state;

  const CategoriesSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    final double actionSize = SizeConfig.text(0.045).clamp(12.0, 16.0);

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
      return SizedBox(
        height: SizeConfig.height * 0.10,
        child: Center(
          child: CustomTextWidget(
            'لا توجد تصنيفات حالياً',
            color: AppPalette.greyMedium,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.036),
            vertical: SizeConfig.h(0.02),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: CustomTextWidget(
                  "قائمة التصنيفات",
                  fontSize: titleSize,
                  color: colorScheme.secondary,
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.rtl,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRouterName.allCategoriesPage);
                    },
                    child: CustomTextWidget("عرض الكل", fontSize: actionSize),
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Icon(
                    Icons.keyboard_arrow_left,
                    size: actionSize + 2,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
    
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
