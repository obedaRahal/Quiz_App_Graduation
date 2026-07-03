import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  const MyProfileDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final selectedValue = value != null && items.contains(value) ? value : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: SizeConfig.h(0.057),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          menuMaxHeight: SizeConfig.h(0.5),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppPalette.greyMedium,
          ),
          hint: CustomTextWidget(
            hintText,
            fontSize: SizeConfig.text(0.038),
            color: AppPalette.greyMedium,
            textAlign: TextAlign.right,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? AppPalette.fieldColorNDark
                : AppPalette.whiteToGrey,
            contentPadding: EdgeInsets.only(
              right: SizeConfig.w(0.030),
              left: SizeConfig.w(0.020),
              top: SizeConfig.h(0.012),
              bottom: SizeConfig.h(0.012),
            ),
            suffixIcon: SizedBox(
              width: SizeConfig.w(0.105),
              child: Center(
                child: Icon(
                  icon,
                  color: AppPalette.greyMedium,
                  size: SizeConfig.w(0.052),
                ),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: appColors.primaryToPrimaryDark,
                width: 1.2,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerRight,
                child: CustomTextWidget(
                  item,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  fontFamily: AppFont.elMessiriRegular,
                  fontSize: SizeConfig.text(0.038),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              alignment: Alignment.centerRight,
              child: CustomTextWidget(
                item,
                textAlign: TextAlign.right,
                color: appColors.blackTogreyMedium,
                fontFamily: AppFont.elMessiriRegular,
                fontSize: SizeConfig.text(0.034),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
