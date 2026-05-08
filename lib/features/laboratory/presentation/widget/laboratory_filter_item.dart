// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class LaboratoryFilterItem extends StatelessWidget {
//   final String title;
//   final int index;
//   final int selectedIndex;
//   final VoidCallback onTap;

//   const LaboratoryFilterItem({
//     super.key,
//     required this.title,
//     required this.index,
//     required this.selectedIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSelected = selectedIndex == index;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final fontSize = SizeConfig.text(0.04).clamp(11.0, 14.0);
//     final horizontalPadding = SizeConfig.w(0.04);
//     final verticalPadding = SizeConfig.h(0.004);
//     final borderRadius = SizeConfig.w(0.04).clamp(10.0, 16.0);

//     final selectedColor = Theme.of(context).colorScheme.primary;
//     final unselectedColor =
//         isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey;

//     final textSelectedColor = isDark ? AppPalette.black : AppPalette.white;
//     final textUnselectedColor =
//         isDark ? AppPalette.titleWhiteINDark : AppPalette.greyMedium;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(borderRadius),
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           curve: Curves.easeInOut,
//           constraints: BoxConstraints(
//             minWidth: SizeConfig.w(0.18),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding,
//             vertical: verticalPadding,
//           ),
//           decoration: BoxDecoration(
//             color: isSelected ? selectedColor : unselectedColor,
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//           child: Center(
//             child: CustomTextWidget(
//               title,
//               fontSize: fontSize,
//               color: isSelected ? textSelectedColor : textUnselectedColor,
//               fontWeight: FontWeight.w500,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LaboratoryFilterItem extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const LaboratoryFilterItem({
    super.key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fontSize = SizeConfig.text(0.036).clamp(10.0, 14.0);
    final verticalPadding = SizeConfig.h(0.004);
    final borderRadius = SizeConfig.w(0.04).clamp(10.0, 16.0);

    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor =
        isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey;

    final textSelectedColor = isDark ? AppPalette.black : AppPalette.white;
    final textUnselectedColor =
        isDark ? AppPalette.titleWhiteINDark : AppPalette.greyMedium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.012),
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomTextWidget(
                title,
                fontSize: fontSize,
                color: isSelected ? textSelectedColor : textUnselectedColor,
                fontWeight: FontWeight.w500,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}