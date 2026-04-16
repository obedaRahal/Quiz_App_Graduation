import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class OnboardingOptionSelectedCard extends StatelessWidget {
//   final String label;
//   final FaIconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   final Color backgroundColor;
//   final Color borderColor;
//   final Color textColor;

//   const OnboardingOptionSelectedCard({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//     required this.backgroundColor,
//     required this.borderColor,
//     required this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: onTap,
//         child: Ink(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.w(0.04),
//             vertical: SizeConfig.h(0.015),
//           ),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: CustomTextWidget(
//                   label,
//                   textAlign: TextAlign.right,
//                   color: textColor,
//                   fontSize: SizeConfig.text(0.038),
//                   //fontFamily: AppFont.elMessiriSemiBold,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(width: SizeConfig.w(0.03)),
//               FaIcon(icon, color: textColor, size: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class OnboardingOptionSelectedCard extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const OnboardingOptionSelectedCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (selectedBackgroundColor ?? AppPalette.primarySoft)
        : (unselectedBackgroundColor ?? AppPalette.grey);

    final borderColor = isSelected
        ? (selectedBorderColor ?? AppPalette.primary)
        : (unselectedBorderColor ?? AppPalette.greyLight);

    final textColor = isSelected
        ? (selectedTextColor ?? AppPalette.primary)
        : (unselectedTextColor ?? AppPalette.black);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.04),
            vertical: SizeConfig.h(0.015),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomTextWidget(
                  label,
                  textAlign: TextAlign.right,
                  color: textColor,
                  fontSize: SizeConfig.text(0.038),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: SizeConfig.w(0.03)),
              FaIcon(icon, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}