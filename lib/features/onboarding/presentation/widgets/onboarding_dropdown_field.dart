import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/utils/media_query_config.dart';

class OnboardingDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  final String hintText;

  /// يبني النص الأساسي لكل عنصر
  final String Function(T item) labelBuilder;

  /// اختياري: لو أردت بناء عنصر مخصص داخل القائمة
  final Widget Function(T item)? itemBuilder;

  /// اختياري: لو أردت بناء العنصر المحدد المعروض داخل الحقل
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
    SizeConfig.init(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: SizeConfig.h(0.075),
        child: DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          hint: CustomTextWidget(
            hintText,
            fontSize: 13,
            color: AppPalette.greyMedium,
            textAlign: TextAlign.right,
          ),
          decoration: _buildDropdownDecoration(),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              alignment: Alignment.centerRight,
              child: itemBuilder != null
                  ? itemBuilder!(item)
                  : CustomTextWidget(
                      labelBuilder(item),
                      textAlign: TextAlign.right,
                      fontSize: SizeConfig.text(0.036),
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
      ),
    );
  }

  InputDecoration _buildDropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: isEnabled ? AppPalette.grey : AppPalette.greyLight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.01),
      ),
      border: _outlineBorder(),
      enabledBorder: _outlineBorder(width: 2),
      focusedBorder: _outlineBorder(
        color: AppPalette.primary,
        width: 1.4,
      ),
      disabledBorder: _outlineBorder(
        color: AppPalette.greyLight,
        width: 1.4,
      ),
      errorBorder: _outlineBorder(color: Colors.red, width: 1.4),
      focusedErrorBorder: _outlineBorder(color: Colors.red, width: 1.6),
    );
  }

  OutlineInputBorder _outlineBorder({
    Color? color,
    double width = 1.4,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color ?? AppPalette.greyLight,
        width: width,
      ),
    );
  }
}