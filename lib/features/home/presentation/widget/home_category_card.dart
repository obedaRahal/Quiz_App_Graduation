import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/data/models/home_category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel item;

  const CategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: SizeConfig.width * 0.34,
      height: SizeConfig.height * 0.03,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.primaryToWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xff5E88FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: isDark ? AppPalette.black : AppPalette.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: SizeConfig.diagonal * .015,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),

                CustomTextWidget(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  fontSize: SizeConfig.diagonal * .013,
                  color: isDark
                      ? AppPalette.titleWhiteINDark
                      : AppPalette.greyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
