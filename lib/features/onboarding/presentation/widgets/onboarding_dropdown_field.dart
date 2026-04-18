import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/utils/media_query_config.dart';

// class OnboardingDropdownField<T> extends StatelessWidget {
//   final T? value;
//   final List<T> items;
//   final ValueChanged<T?> onChanged;

//   final String hintText;

//   /// يبني النص الأساسي لكل عنصر
//   final String Function(T item) labelBuilder;

//   /// اختياري: لو أردت بناء عنصر مخصص داخل القائمة
//   final Widget Function(T item)? itemBuilder;

//   /// اختياري: لو أردت بناء العنصر المحدد المعروض داخل الحقل
//   final Widget Function(T item)? selectedItemBuilder;

//   final bool isEnabled;

//   const OnboardingDropdownField({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     required this.hintText,
//     required this.labelBuilder,
//     this.itemBuilder,
//     this.selectedItemBuilder,
//     this.isEnabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     //SizeConfig.init(context);

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: SizedBox(
//         //height: SizeConfig.h(0.075),
//         child: DropdownButtonFormField<T>(
//           value: value,
//           isExpanded: true,
//           menuMaxHeight: SizeConfig.h(0.5),
//           icon: const Icon(Icons.keyboard_arrow_down_rounded ,color: AppPalette.greyMedium,),
//           hint: CustomTextWidget(
//             hintText,
//             fontSize: 12,
//             color: AppPalette.greyMedium,
//             textAlign: TextAlign.right,
//           ),
//           decoration: _buildDropdownDecoration(),
//           items: items.map((item) {
//             return DropdownMenuItem<T>(
//               value: item,
//               alignment: Alignment.centerRight,
//               child: itemBuilder != null
//                   ? itemBuilder!(item)
//                   : CustomTextWidget(
//                       labelBuilder(item),
//                       textAlign: TextAlign.right,
//                       fontSize: SizeConfig.text(0.035),
//                     ),
//             );
//           }).toList(),
//           selectedItemBuilder: selectedItemBuilder == null
//               ? null
//               : (context) {
//                   return items.map((item) {
//                     return selectedItemBuilder!(item);
//                   }).toList();
//                 },
//           onChanged: isEnabled ? onChanged : null,
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildDropdownDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: isEnabled ? AppPalette.grey : AppPalette.greyLight,
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.w(0.04),
//         //vertical: SizeConfig.h(0.01),
//       ),
//       border: _outlineBorder(),
//       enabledBorder: _outlineBorder(width: 2),
//       focusedBorder: _outlineBorder(
//         color: AppPalette.primary,
//         width: 1.4,
//       ),
//       disabledBorder: _outlineBorder(
//         color: AppPalette.greyLight,
//         width: 1.4,
//       ),
//       errorBorder: _outlineBorder(color: Colors.red, width: 1.4),
//       focusedErrorBorder: _outlineBorder(color: Colors.red, width: 1.6),
//     );
//   }

//   OutlineInputBorder _outlineBorder({
//     Color? color,
//     double width = 1.4,
//   }) {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: color ?? AppPalette.greyLight,
//         width: width,
//       ),
//     );
//   }
// }


class OnboardingDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  final String hintText;

  final String Function(T item) labelBuilder;
  final Widget Function(T item)? itemBuilder;
  final Widget Function(T item)? selectedItemBuilder;

  final bool isEnabled;

  const OnboardingDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.labelBuilder,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final fillColor = isEnabled
        ? appColors.greyToGreyMediumDark
        : appColors.greyToGreyMediumDark;

    final borderColor =
        appColors.borderFieldColorNLightToborderFieldColorNDark;

    final focusColor = appColors.primaryToPrimaryDark;
    final secondaryTextColor = appColors.blackTogreyMedium;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        menuMaxHeight: SizeConfig.h(0.5),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: secondaryTextColor,
        ),
        hint: CustomTextWidget(
          hintText,
          fontSize: 12,
          color: secondaryTextColor,
          textAlign: TextAlign.right,
        ),
        decoration: _buildDropdownDecoration(
          fillColor: fillColor,
          borderColor: borderColor,
          focusColor: focusColor,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            alignment: Alignment.centerRight,
            child: itemBuilder != null
                ? itemBuilder!(item)
                : CustomTextWidget(
                    labelBuilder(item),
                    textAlign: TextAlign.right,
                    fontSize: SizeConfig.text(0.035),
                    color: secondaryTextColor,
                  ),
          );
        }).toList(),
        selectedItemBuilder: selectedItemBuilder == null
            ? null
            : (context) {
                return items.map((item) {
                  return selectedItemBuilder!(item);
                }).toList();
              },
        onChanged: isEnabled ? onChanged : null,
      ),
    );
  }

  InputDecoration _buildDropdownDecoration({
    required Color fillColor,
    required Color borderColor,
    required Color focusColor,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
      ),
      border: _outlineBorder(
        color: borderColor,
      ),
      enabledBorder: _outlineBorder(
        color: borderColor,
        width: 2,
      ),
      focusedBorder: _outlineBorder(
        color: focusColor,
        width: 1.4,
      ),
      disabledBorder: _outlineBorder(
        color: borderColor,
        width: 1.4,
      ),
      errorBorder: _outlineBorder(
        color: Colors.red,
        width: 1.4,
      ),
      focusedErrorBorder: _outlineBorder(
        color: Colors.red,
        width: 1.6,
      ),
    );
  }

  OutlineInputBorder _outlineBorder({
    required Color color,
    double width = 1.4,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}