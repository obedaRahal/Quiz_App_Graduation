import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class OtherProfileHorizontalFilterSection<T> extends StatelessWidget {
  final T selectedFilter;
  final List<OtherProfileFilterOption<T>> filters;
  final ValueChanged<T> onFilterSelected;

  const OtherProfileHorizontalFilterSection({
    super.key,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          textDirection: TextDirection.rtl,
          children: filters.map((item) {
            return Padding(
              padding: EdgeInsets.only(left: SizeConfig.w(0.02)),
              child: _OtherProfileFilterChip(
                title: item.title,
                isSelected: selectedFilter == item.value,
                onTap: () => onFilterSelected(item.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class OtherProfileFilterOption<T> {
  final String title;
  final T value;

  const OtherProfileFilterOption({required this.title, required this.value});
}

class _OtherProfileFilterChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _OtherProfileFilterChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fontSize = SizeConfig.text(0.033).clamp(11.0, 14.0);
    final horizontalPadding = SizeConfig.w(0.035);
    final verticalPadding = SizeConfig.h(0.003);
    final borderRadius = SizeConfig.w(0.04).clamp(10.0, 16.0);

    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = isDark
        ? AppPalette.greyMediumDark
        : AppPalette.whiteToGrey;

    final textSelectedColor = isDark ? AppPalette.black : AppPalette.white;
    final textUnselectedColor = isDark
        ? AppPalette.titleWhiteINDark
        : AppPalette.greyMedium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(minWidth: SizeConfig.w(0.18)),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(borderRadius),
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
