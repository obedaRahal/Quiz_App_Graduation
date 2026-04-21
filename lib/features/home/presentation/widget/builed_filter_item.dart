import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_state.dart';

class FilterItem extends StatelessWidget {
  final String title;
  final int index;
  final HomeState state;
  final VoidCallback? onTap;

  const FilterItem({
    super.key,
    required this.title,
    required this.index,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = state.filterIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔥 Responsive values
    final fontSize = SizeConfig.text(0.04).clamp(11.0, 14.0);
    final horizontalPadding = SizeConfig.w(0.04);
    final verticalPadding = SizeConfig.h(0.004);
    final borderRadius = SizeConfig.w(0.04).clamp(10.0, 16.0);

    // 🎯 colors
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = isDark
        ? AppPalette.greyMediumDark
        : AppPalette.whiteToGrey;
    final textSelectedColor = isDark ? AppPalette.black : AppPalette.white;
    final textUnselectedColor = isDark
        ? AppPalette.titleWhiteINDark
        : AppPalette.greyMedium;

    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            minWidth: SizeConfig.w(0.18), // 🔥 مهم للـ responsiveness
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(borderRadius),
            // border: Border.all(
            //   color: isSelected ? selectedColor : Colors.grey.withOpacity(0.4),
            //   width: isSelected ? 1.5 : 1,
            // ),
          ),
          child: Center(
            child: CustomTextWidget(
              title,
              fontSize: fontSize,
              color: isSelected ? textSelectedColor : textUnselectedColor,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
