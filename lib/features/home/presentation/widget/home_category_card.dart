import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_interests_response_entity.dart';

class CategoryCard extends StatelessWidget {
  final RecommendedInterestEntity item;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconUrl = item.iconSvg;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: SizeConfig.width * 0.36,
        height: SizeConfig.height * 0.03,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: isDark
              ? AppPalette.fieldColorNDark
              : AppPalette.primaryToWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isDark ? AppPalette.primaryDark : AppPalette.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomAppImage(
                  path: iconUrl,
                  fit: BoxFit.contain,
                  color: isDark ? AppPalette.black : AppPalette.white,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: SizeConfig.text(0.025).clamp(11.0, 13.0),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
                  ),
                  CustomTextWidget(
                    '${item.testsCount} اختبار',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    fontSize: SizeConfig.text(0.025).clamp(9.0, 14.0),
                    color: isDark
                        ? AppPalette.titleWhiteINDark
                        : AppPalette.greyMedium,
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
