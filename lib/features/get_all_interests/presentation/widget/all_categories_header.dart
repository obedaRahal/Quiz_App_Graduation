import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class AllCategoriesHeader extends StatelessWidget {
  const AllCategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.01),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: SizeConfig.h(0.055),
          child: SizedBox(
            height: SizeConfig.h(0.055),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'قائمة التصنيفات',
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.text(0.052),
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),

                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: SizeConfig.w(0.095),
                    height: SizeConfig.w(0.095),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppPalette.fieldColorNDark
                          : const Color(0xFFF6F6F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: SizeConfig.text(0.045),
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
