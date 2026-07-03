import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileGenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MyProfileGenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  bool get _isMale {
    final text = value.trim().toLowerCase();
    return text == 'ذكر' || text == 'male';
  }

  bool get _isFemale {
    final text = value.trim().toLowerCase();
    return text == 'أنثى' || text == 'انثى' || text == 'female';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'الجنس',
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.034),
        ),

        SizedBox(height: SizeConfig.h(0.008)),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _GenderOption(
              isSelected: _isMale,
              assetPath: AppImage.male,
              onTap: () => onChanged('ذكر'),
            ),

            SizedBox(width: SizeConfig.w(0.03)),

            _GenderOption(
              isSelected: _isFemale,
              assetPath: AppImage.female,
              onTap: () => onChanged('انثى'),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final bool isSelected;
  final String assetPath;
  final VoidCallback onTap;

  const _GenderOption({
    required this.isSelected,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final iconSize = SizeConfig.w(0.055);
    final iconPadding = SizeConfig.w(0.023);

    final selectedBackground = isDark
        ? appColors.primaryToPrimaryDark
        : AppPalette.primarySoftMore;

    final unselectedBackground = isDark
        ? AppPalette.fieldColorNDark
        : AppPalette.white;

    final selectedBorder = appColors.primaryToPrimaryDark;

    final unselectedBorder = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.greyBorder;

    final selectedIconColor = isDark ? AppPalette.black : AppPalette.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(iconPadding),
        decoration: BoxDecoration(
          color: isSelected ? selectedBackground : unselectedBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: 2,
          ),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: iconSize,
          height: iconSize,
          color: isSelected ? selectedIconColor : AppPalette.greyMedium,
        ),
      ),
    );
  }
}