import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/data/models/home_category_model.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_category_card.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    double actionSize = SizeConfig.text(0.045).clamp(12.0, 16.0);
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
                // 🔥 مهم لتجنب overflow
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
                  CustomTextWidget("عرض الكل", fontSize: actionSize),
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
        const SizedBox(height: 14),
        SizedBox(
          height: SizeConfig.height * 0.07,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = categories[index];
              return CategoryCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}
